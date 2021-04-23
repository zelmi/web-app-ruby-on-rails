class UsersController < ApplicationController
  def new
  @user = User.new
  end

  def create
        if User.find_by(name: params[:name])
          return
        end

        @user = User.create(params.require(:user).permit(:name, :email, :user_type, :password))
        if @user.save
        	session[:user_id] = @user.id    
        	flash[:success] = "Successfully created the account"  
        	redirect_to "/"
        else
        	flash[:warning] = "Duplicate user entered!"
          redirect_to "/users/new"
        end
  end
end
