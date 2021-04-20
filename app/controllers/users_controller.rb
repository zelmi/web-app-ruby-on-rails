class UsersController < ApplicationController
  def new
  @user = User.new
  end

  def create
          if User.find_by(name: params[:name])
            return
        end

        @user = User.create(params.require(:user).permit(:name, :user_type, :password))
        if @user.save
        	session[:user_id] = @user.id    
        	flash[:success] = "Success!"  
        else
        	flash[:warning] = "Something went wrong!"
        end
               redirect_to "/", notice: "Successfully created the account"
  end
end
