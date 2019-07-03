require 'google/apis/classroom_v1'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require 'fileutils'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'.freeze
APPLICATION_NAME = 'Classroom API Ruby Quickstart'.freeze
CREDENTIALS_PATH = 'credentials.json'.freeze
TOKEN_PATH = 'token.yaml'.freeze
SCOPE = [Google::Apis::ClassroomV1::AUTH_CLASSROOM_ANNOUNCEMENTS,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_ANNOUNCEMENTS_READONLY,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_COURSES,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_COURSES_READONLY,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_COURSEWORK_ME,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_COURSEWORK_ME_READONLY,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_COURSEWORK_STUDENTS,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_COURSEWORK_STUDENTS_READONLY,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_GUARDIANLINKS_ME_READONLY,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_GUARDIANLINKS_STUDENTS,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_GUARDIANLINKS_STUDENTS_READONLY,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_PROFILE_EMAILS,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_PROFILE_PHOTOS,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_PUSH_NOTIFICATIONS,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_ROSTERS,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_ROSTERS_READONLY,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_STUDENT_SUBMISSIONS_ME_READONLY,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_STUDENT_SUBMISSIONS_STUDENTS_READONLY,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_TOPICS,
         Google::Apis::ClassroomV1::AUTH_CLASSROOM_TOPICS_READONLY]

##
# Ensure valid credentials, either by restoring from the saved credentials
# files or intitiating an OAuth2 authorization. If authorization is required,
# the user's default browser will be launched to approve the request.
#
# @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
def authorize
  client_id = Google::Auth::ClientId.from_file(CREDENTIALS_PATH)
  token_store = Google::Auth::Stores::FileTokenStore.new(file: TOKEN_PATH)
  authorizer = Google::Auth::UserAuthorizer.new(client_id, SCOPE, token_store)
  user_id = 'default'
  credentials = authorizer.get_credentials(user_id)
  if credentials.nil?
    url = authorizer.get_authorization_url(base_url: OOB_URI)
    puts 'Open the following URL in the browser and enter the ' \
         "resulting code after authorization:\n" + url
    code = gets
    credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI
    )
  end
  credentials
end

# Initialize the API
service = Google::Apis::ClassroomV1::ClassroomService.new
service.client_options.application_name = APPLICATION_NAME
service.authorization = authorize
