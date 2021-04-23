class RegisterController < ApplicationController
    def login
    end


    def logout
        session[:user_id] = nil
        flash[:logout] = "Successfully logged out" 
        redirect_to "/", notice: "Successfully logged out"
    end
    def create
        if User.find_by(name: params[:name])
            return
        end

        user =  User.new(name: params[:name], user_type: params[:user_type], password: params[:password])
        if user.save
        	session[:user_id] = user.id    
        	flash[:success] = "Success!"  
       	    redirect_to "/", notice: "Successfully created the account"
        else
        	flash[:warning] = "Something went wrong!"
            redirect_to "/users/new", notice: "Duplicate user entered!"
        end
    end

    def handle_login
        user = User.find_by(name: params[:name])

        if user == nil 
        flash[:warning] = "Invalid credentials"
            return ""
        end

        if !user.authenticate(params[:password])
        flash[:warning] = "Invalid credentials"
            return ""
        end

        session[:user_id] = user.id

        redirect_to "/"
    end
end
