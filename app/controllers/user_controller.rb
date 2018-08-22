class UserController < ApplicationController

    get '/:user_slug/profile/edit' do
        authorize_slug(params[:user_slug])
        erb :"users/profile"
    end

    get '/:user_slug/following' do
        authorize_slug(params[:user_slug])
        @user = UserAPIDecorator.new(user: current_user)

    end
    
end