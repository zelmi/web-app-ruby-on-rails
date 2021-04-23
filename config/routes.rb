Rails.application.routes.draw do
  resources :users, only: [:new, :create]
  get "/" => "main#index"

  get "/course/:id" => "main#course"
  get "/survey/:id" => "main#survey"

  get "/logout" => "register#logout"

  get "/login" => "register#login"
  post "/login" => "register#handle_login"

  get "/createcourse" => "main#createcourse"
  post "/createcourse" => "main#handle_create_course"
  
  get "/creategroup/:courseId" => "main#creategroup"
  get "/addstudents/:courseId" => "main#addstudents"
  get "download_json" => "main#download_json"
  get "/createsurvey/:courseId" => "main#createsurvey"

  post "/handle_new_course_student" => "main#handle_new_course_student"
  post "/handle_new_student_group" => "main#handle_new_student_group"
  post "/handle_new_survey" => "main#handle_new_survey"
  post "/handle_survey_submit" => "main#handle_survey_submit"
  post "/handle_reset_data" => "main#handle_reset_data"
  post "/handle_generate_data" => "main#handle_generate_data"
  post "/handle_new_group_2" => "main#handle_new_group_2"
  post "/handle_add_students" => "main#handle_add_students"
  post "/handle_create_survey" => "main#handle_create_survey"
end
