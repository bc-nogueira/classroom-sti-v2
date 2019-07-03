class UserProfile
  # @param [String] user_id
  #   Identifier of the profile to return. The identifier can be one of the
  #   following:
  #   * the numeric identifier for the user
  #   * the email address of the user
  #   * the string literal `"me"`, indicating the requesting user
  def find_user_profile(user_id)
    user_profile = service.get_user_profile(user_id)
    puts "Nome: #{user_profile.name.full_name}"
    puts "Email: #{user_profile.email_address}"
    puts "Photo URL: #{user_profile.photo_url}"
  end
end
