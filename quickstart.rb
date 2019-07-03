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

# 31092837121
# List the first 10 courses the user has access to.
# response = service.list_courses
# puts 'Cursos:'
# puts 'No courses found' if response.courses.empty?
# response.courses.each do |course|
#   puts "- #{course.name} (#{course.id}) - #{course.owner_id}"
# end

# Get course by id
# course = service.get_course(37277370323)
# puts "#{course.name} - #{course.course_state}"

# Get teacher from course
# response = service.list_course_teachers('31092837121')
# puts 'Professores:'
# puts 'No teachers found' if response.teachers.empty?
# response.teachers.each do |teacher|
#   puts "#{teacher.user_id} - #{teacher.profile.name.full_name}"
# end

# Get students from course
# puts 'Alunos:'
# response = nil
# page_token = nil
# begin
#   response = service.list_course_students('31092837121', page_token: page_token)
#   response.students.each do |student|
#     puts "#{student.profile.name.full_name}"
#   end
#   page_token = response&.next_page_token
#   puts "#{page_token}"
# end while(page_token)
# puts 'No students found' if response.empty?

# response = service.get_user_profile('bcnogueira@id.uff.br')
# puts "#{response.name}"

# CREATE A COURSE
# course = Google::Apis::ClassroomV1::Course.new({ name: "Testando 1", owner_id: 'me', course_state: 'ACTIVE' })
# puts "Curso a ser criado: #{course.name} - #{course.owner_id} - #{course.id}"
# created_course = service.create_course(course)
# puts "Resultado: #{created_course.name} - #{created_course.id}"
#
# TODO: Mais nova: 37277370323
# DELETE A COURSE
service.delete_course(37277370323)

# CREATE TEACHER
# # TODO: Testar pegando o profile buscando por email e assim passando os dados para o novo aluno
# teacher = Google::Apis::ClassroomV1::Teacher.new({ course_id: '37277370323', user_id: 'bcnogueira@id.uff.br' })
# puts "Teacher: #{teacher.user_id}"
# created_teacher = service.create_course_teacher('37277370323', teacher)
# puts "Resultado: #{created_teacher.profile.name.full_name} - Curso: #{created_teacher.course_id} - User id: #{teacher.user_id}"

# DELETE TEACHER
# response = service.delete_course_teacher('37277370323', 'bcnogueira@id.uff.br')
# puts "Resultado: #{response}"

# GET TEACHER
# teacher = service.get_course_teacher('37277370323', 'bcnogueira@id.uff.br')
# puts "Nome: #{teacher.profile.name.full_name}"

# CREATE STUDENT
# TODO: Testar pegando o profile buscando por email e assim passando os dados para o novo aluno
# user_profile = service.get_user_profile('bcnogueira@id.uff.br')
# student = Google::Apis::ClassroomV1::Student.new({ course_id: '37277370323', user_id: user_profile.id, profile: user_profile })
# # student = Google::Apis::ClassroomV1::Student.new({ course_id: '37277370323', user_id: 'bcnogueira@id.uff.br' })
# puts "Student: #{student.user_id}"
# created_student = service.create_course_student('37277370323', student)
# puts "Resultado: #{created_student.profile.name.full_name} - Curso: #{created_student.course_id} - User id: #{created_student.user_id}"

# DELETE STUDENT
# response = service.delete_course_student('37277370323', 'bcnogueira@id.uff.br')
# puts "Resultado: #{response}"

# GET STUDENT
# student = service.get_course_student('37277370323', 'bcnogueira@id.uff.br')
# puts "Nome: #{student.profile.name.full_name}"

# GET USER PROFILE
# user_profile = service.get_user_profile('bcnogueira@id.uff.br')
# puts "Nome: #{user_profile.name.full_name}"
# puts "Email: #{user_profile.email_address}"
# puts "Photo URL: #{user_profile.photo_url}"
