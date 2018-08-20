class AuthenticationController < ApplicationController

    get '/login' do
        redirect '/' if authorized?
        erb :"authenticate/login"
    end

    get '/signup' do
        redirect '/' if authorized?
        erb :"authenticate/signup"
    end

    post '/login' do
        redirect '/' if authorized?
        if ((user = User.find_by(username: params[:username])) && user.authenticate(params[:password]))
          session[:user_id] = user.id
          redirect '/'
        else
          @error = "Improper credentials entered"
          erb :"/authenticate/login"
        end
    end

    post '/signup' do
        redirect '/' if authorized?
        user = User.new(params[:user])
        if user.save
          session[:user_id] = user.id
          redirect '/'
        else
          @errors = user.errors.messages
          erb :"/authenticate/signup"
        end
    end
end
