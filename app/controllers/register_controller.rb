class RegisterController < ApplicationController
    def login
    end

    def signup
    end

    def logout
        session[:user_id] = nil
        redirect_to "/", notice: "Successfully logged out"
    end

    def create
        if User.find_by(name: params[:name])
            return
        end

        User.new(name: params[:name], user_type: params[:user_type], password: params[:password]).save
        user = User.find_by(name: params[:name])

        session[:user_id] = user.id
        
        redirect_to "/", notice: "Successfully created the account"
    end

    def handle_login
        user = User.find_by(name: params[:name])

        if user == nil 
            return ""
        end

        if params[:password] != user.password
            return ""
        end

        session[:user_id] = user.id

        redirect_to "/"
    end
end
