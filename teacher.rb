class Teacher
  def find_course_teacher(course_id, user_id)
    teacher = service.get_course_teacher(course_id, user_id)
    puts "Nome: #{teacher.profile.name.full_name}"
  end

  def create_course_teacher(user_id, course_id)
    user_profile = service.get_user_profile(user_id)
    teacher = Google::Apis::ClassroomV1::Teacher.new(course_id: course_id,
                                                     user_id: user_id,
                                                     profile: user_profile)
    # teacher = Google::Apis::ClassroomV1::Teacher.new(course_id: course_id,
    #                                                  user_id: user_id)
    created_teacher = service.create_course_teacher('37277370323', teacher)
    puts "Resultado: #{created_teacher.profile.name.full_name} " |
         "- Curso: #{created_teacher.course_id} - User id: #{teacher.user_id}"
  end

  def delete_course_teacher(course_id, user_id)
    response = service.delete_course_teacher(course_id, user_id)
    puts "Resultado: #{response}"
  end
end
