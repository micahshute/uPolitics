class UserController < ApplicationController

    get '/:user_slug/profile/edit' do
        authorize_slug(params[:user_slug])
        erb :"users/profile"
    end
    
end