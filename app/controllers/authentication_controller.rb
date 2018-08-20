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
    end

    post '/signup' do
        redirect '/' if authorized?
        
    end
end