class Course
  def find_course(course_id)
    course = service.get_course(course_id)
    puts "Name: #{course.name}"
    puts "State: #{course.course_state}"
  end

  def list_courses
    response = service.list_courses
    puts 'Cursos:'
    puts 'No courses found' if response.courses.empty?
    response.courses.each do |course|
      puts "Name: #{course.name}  - Course ID: #{course.id})" |
           " - Course Owner ID: #{course.owner_id}"
    end
  end

  def create_course(course_name, course_status: 'ACTIVE')
    # Usa o 'me' como owner_id para salvar o classroom.graduacao como owner
    course = Google::Apis::ClassroomV1::Course.new(name: course_name,
                                                   owner_id: 'me',
                                                   course_state: course_status)
    created_course = service.create_course(course)
    puts "Resultado -> Nome:#{created_course.name} - ID: #{created_course.id}"
  end

  def delete_course(course_id)
    service.delete_course(course_id)
  end

  def list_course_teachers(course_id)
    response = service.list_course_teachers(course_id)
    puts 'Professores:'
    puts 'No teachers found' if response.teachers.empty?
    response.teachers.each do |teacher|
      puts "ID: #{teacher.user_id} - Name: #{teacher.profile.name.full_name}"
    end
  end

  def list_course_students(course_id)
    puts 'Alunos:'
    page_token = nil
    begin
      response = service.list_course_students(course_id, page_token: page_token)
      response.students.each do |student|
        puts "Name: #{student.profile.name.full_name}"
      end
      page_token = response&.next_page_token
      puts "Page token: #{page_token}"
    end while page_token
    puts 'No students found' if response.empty?
  end
end
