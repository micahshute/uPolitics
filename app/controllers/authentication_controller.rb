class AuthenticationController < ApplicationController

    get '/login' do
        redirect '/' if authorized?
        erb :"authenticate/login"
    end

    get '/signup' do
        redirect '/' if authorized?
        erb :"authenticate/signup"
    end

    get '/profile' do
        authorize
        erb :"users/profile"
    end

    get '/profile/:state' do
        state_info = params[:state].split('_')
        @state_hash = {
            name: state_info[0].split('-').join(' '),
            abbreviation: state_info[1]
        }
        
        "Show state details"
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
          redirect '/profile'
        else
          @errors = user.errors.messages
          erb :"/authenticate/signup"
        end
    end

    post '/profile/:state' do
        authorize
        state = State.new(params[:state])
        current_user.state = state
        current_user.save
        redirect '/signup/verify'
    end

    get '/signup/verify' do
        @user = UserAPIDecorator.new(current_user, APIManager)
        erb :"authenticate/verify_setup"
    end
    
end
