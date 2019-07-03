class Student
  def find_course_student(course_id, user_id)
    student = service.get_course_student(course_id, user_id)
    puts "Nome: #{student.profile.name.full_name}"
  end

  def create_course_student(user_id, course_id)
    user_profile = service.get_user_profile(course_id)
    student = Google::Apis::ClassroomV1::Student.new(course_id: course_id,
                                                     user_id: user_id,
                                                     profile: user_profile)
    # student = Google::Apis::ClassroomV1::Student.new(course_id: course_id,
    #                                                  user_id: user_id)
    created_student = service.create_course_student('37277370323', student)
    puts "Resultado: #{created_student.profile.name.full_name} " |
         "- Curso: #{created_student.course_id} " |
         "- User id: #{created_student.user_id}"
  end

  def delete_course_student(course_id, user_id)
    response = service.delete_course_student(course_id, user_id)
    puts "Resultado: #{response}"
  end
end
