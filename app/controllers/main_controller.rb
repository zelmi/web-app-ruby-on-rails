class MainController < ApplicationController
    def index
        if !@current_user 
        elsif @current_user.user_type == "instructor"
            @courses = Course.where(instructorId: @current_user.id)
        elsif @current_user.user_type == "student"
            @courses = Course.where(id: StudentCourse.where(studentId: @current_user.id).map {|sc| sc.courseId })
            @surveys = StudentGroupSurvey.where(student_id: @current_user.id, completed: false)
        end 
    end

    def survey
        if !@current_user
        elsif @current_user.user_type == "student"
            @student_group_survey = StudentGroupSurvey.find(params[:id])
            @group_survey = GroupSurvey.find(@student_group_survey.group_surveyId)
            @group = Group.find(@group_survey.groupId)
            @survey = Survey.find(@group_survey.surveyId)
            @student_group = StudentGroup.where(groupId: @group.id)
            @other_students = User.where(id: @student_group.map {|sg| sg.studentId })
            @i = 0
        else
            @survey = Survey.find(params[:id])
            @course = Course.find(@survey.courseId)
            group_surveys = GroupSurvey.where(surveyId: @survey.id)
            @text_responses = TextResponse.where(group_surveyId: group_surveys.map {|gs| gs.id })
            @groups = Group.where(courseId: @survey.courseId)
        end
    end

    def handle_create_course
        course = Course.new({
            name: params[:name],
            instructorId: @current_user.id
        })

        if course.save
            redirect_to "/", notice: "Successfully created the course"
        end
    end

    def course
        @course = Course.find(params[:id])
        @students = User.where(id: StudentCourse.where(courseId: @course.id).map {|sc| sc.studentId })
        @groups = Group.where(courseId: @course.id)
        @surveys = Survey.where(courseId: @course.id)
        @all_students_in_group = all_students_in_group?(@course.id)
    end

    def creategroup
        courseId = params[:courseId]

        @course = Course.find(courseId)

        student_courses = StudentCourse.where(courseId: @course.id)

        @students = User.where(id: student_courses.map {|sc| sc.studentId })
    end

    def handle_new_group_2
        num_students = params[:num_students].to_i
        group_name = params[:group_name]
        courseId = params[:courseId]

        course = Course.find(courseId)

        if Group.find_by(name: group_name, courseId: courseId)
            return
        end

        Group.new(name: group_name, courseId: courseId).save
        group = Group.find_by(name: group_name, courseId: courseId)

        (1..num_students).each do |i|
            student_selected = params["student#{i}_selected"].to_i

            puts student_selected
            puts student_selected == 1

            if student_selected == 1
                studentId = params["student#{i}_id"]
                StudentGroup.new(studentId: studentId, groupId: group.id).save
            end
        end

        redirect_to "/course/#{course.id}", notice: "yay!"
    end

    def addstudents
        courseId = params[:courseId]
        @course = Course.find(courseId)
    end
	def download_json
  	send_file(
    "#{Rails.root}/public/example.json",
    filename: "example.json",
    type: "application/json"
  	)
	end
    def handle_add_students
    	#check if file is valid json file in valid format
        if params[:file] == nil
              flash[:error0] = "Error: Please upload a file." 
        else
              file = params[:file].read	
            student = nil
	    ActiveSupport::JSON.decode(file)["students"].each do |user|
            student = User.find_by(name: user["name"], email: user["email"])
            
            if user["name"] == nil or user["email"] == nil
            	flash[:error1] = "Error: improperly formatted json file."
            	break
            end
            
            if student == nil and user["name"] != nil
            	flash[:error] = "Error, Student " + user["name"] + " does not exist in our data"
            	break
            end
            
            StudentCourse.new(studentId: student.id, courseId: params[:courseId]).save
        end
        end
	if student != nil
        	redirect_to "/course/#{params[:courseId]}", notice: "yay!"
       else
      		 redirect_to "/addstudents/#{params[:courseId]}"
        end
    end

    def handle_new_course_student
        student = User.find_by(name: params[:student_name])

        if !student 
            return
        elsif student.user_type != "student"
            return
        elsif StudentCourse.find_by(studentId: student.id, courseId: params[:courseId])
            return
        end

        StudentCourse.new({ studentId: student.id, courseId: params[:courseId] }).save

        redirect_to "/", notice: "yay!"
    end

    def handle_new_student_group
        student = User.find_by(name: params[:student_name])

        if !student
            return
        end

        if !Group.find_by(name: params[:name])
            group = Group.new({ name: params[:name], courseId: params[:courseId] })
            group.save
        end

        group_id = Group.find_by(name: params[:name], courseId: params[:courseId]).id

        if !StudentGroup.find_by({ studentId: student.id, groupId: group_id })
            student_group = StudentGroup.new({ studentId: student.id, groupId: group_id })
            student_group.save
        end
        
        redirect_to "/", notice: "yay!"
    end
    
    def createsurvey
        @courseId = params[:courseId]
    end

    def handle_create_survey
        Survey.new(name: params[:name], courseId: params[:courseId]).save
        survey = Survey.find_by(name: params[:name], courseId: params[:courseId])

        groups = Group.where(courseId: params[:courseId])

        groups.each do |group|
            group_survey = GroupSurvey.new(groupId: group.id, surveyId: survey.id)
            group_survey.save
        end

        StudentCourse.where(courseId: params[:courseId]).each do |sc|
            student_group = StudentGroup.find_by(groupId: groups.map {|g| g.id}, studentId: sc.studentId)

            if !student_group
                next
            end

            group_survey = GroupSurvey.find_by(groupId: student_group.groupId, surveyId: survey.id)

            student_group_survey = StudentGroupSurvey.new({
                student_id: sc.studentId,
                group_surveyId: group_survey.id,
                completed: false
            })
            
            student_group_survey.save
        end

        redirect_to "/course/#{params[:courseId]}", notice: "yay!"
    end

    def handle_new_survey
    end

    def handle_survey_submit
        1.upto params[:num_responses].to_i do |i|
            value = params["text#{i}"]
            recepId = params["recep#{i}"]

            text_response = TextResponse.new({ 
                value: value, 
                authorId: params[:author],
                recepId: recepId,
                group_surveyId: params[:group_surveyId],
                question: "question0"
            })

            text_response.save
        end

        StudentGroupSurvey.find(params[:student_group_surveyId]).update(completed: true)

        redirect_to "/", notice: "yay!"
    end

    def handle_reset_data
        User.all.each {|n| n.delete}
        Course.all.each {|n| n.delete}
        GroupSurvey.all.each {|n| n.delete}
        Group.all.each {|n| n.delete}
        StudentCourse.all.each {|n| n.delete}
        StudentGroupSurvey.all.each {|n| n.delete}
        StudentGroup.all.each {|n| n.delete}
        Survey.all.each {|n| n.delete}
        TextResponse.all.each {|n| n.delete}

        session[:user_id] = nil

        redirect_to "/", notice: "yay!"
    end

    def handle_generate_data
        # Make the students
        [1,2,3,4,5,6,7,8,9,10,11,12].each do |i|
            User.new({ name: "student#{i}", password: "123456", user_type: "student", email: "abc#{i}@email.com" }).save
        end

        # Make Charlie
        User.new({ name: 'Charlie', password: "123456", user_type: "instructor", email: "charlie@email.com" }).save
        charlie = User.find_by(name: "Charlie")

        # Make new Web Apps course owned by Charlie
        Course.new({ name: "Web Apps", instructorId: charlie.id }).save
        web_apps = Course.find_by(name: "Web Apps")

        # Add the students to web apps
        [1,2,3,4,5,6,7,8,9,10,11,12].each do |i|
            student = User.find_by(name: "student#{i}")
            StudentCourse.new(studentId: student.id, courseId: web_apps.id).save
        end
        
        # Make a few web apps groups
        [1,2,3].each {|i| Group.new({ name: "g#{i}", courseId: web_apps.id }).save }

        # Assign students to these groups
        [1,2,3,4].each do |i|
            student = User.find_by(name: "student#{i}")
            group = Group.find_by(name: "g1", courseId: web_apps.id)

            StudentGroup.new({ studentId: student.id, groupId: group.id }).save
        end
        [5,6,7,8].each do |i|
            student = User.find_by(name: "student#{i}")
            group = Group.find_by(name: "g2", courseId: web_apps.id)

            StudentGroup.new({ studentId: student.id, groupId: group.id }).save
        end
        [9,10,11,12].each do |i|
            student = User.find_by(name: "student#{i}")
            group = Group.find_by(name: "g3", courseId: web_apps.id)

            StudentGroup.new({ studentId: student.id, groupId: group.id }).save
        end
        
        redirect_to "/", notice: "yay!"
    end

    private

    def all_students_in_group?(courseId)
        studentIds = StudentCourse.where(courseId: courseId).map {|sc| sc.studentId }
        groups = Group.where(courseId: courseId)

        return studentIds.all? {|studentId| StudentGroup.find_by(groupId: groups, studentId: studentId) }
    end
end
