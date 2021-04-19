class ApplicationController < ActionController::Base
    before_action :get_user, :set_debug

    private

    def get_user
        if (session[:user_id])
            @current_user = User.find(session[:user_id])
        end
    end

    def set_debug
        @debug = true
    end
end
