class AuthenticationController < ApplicationController

    get '/login' do
        redirect '/' if authorized?
        erb :"authenticate/login"
    end

    get '/signup' do
        redirect '/' if authorized?
        erb :"authenticate/signup"
    end

    get '/signup/info' do
        authorize
        erb :"users/profile"
    end

    get '/profile/:state' do
        authorize
        state_info = params[:state].split('_')
        state_hash = {
            name: state_info[0].split('-').join(' '),
            abbreviation: state_info[1]
        }
        
        state = State.find_or_create_by(state_hash)
        state.save
        user = current_user
        user.state = state
        @user = UserAPIDecorator.new(user: user)
        erb :"authenticate/verify_setup"
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
          redirect '/signup/info'
        else
          @errors = user.errors.messages
          erb :"/authenticate/signup"
        end
    end

    post '/profile/:state' do
        authorize
        state_split = params[:state].split("_")
        state_hash = {
            name: state_split[0].split('-').join(' '),
            abbreviation: state_split[1]
        }
        state = State.find_or_create_by(state_hash)
        user = current_user
        user.state = state
        user.save
        redirect '/'
    end
    
end
