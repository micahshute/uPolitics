require './config/environment'

class ApplicationController < Sinatra::Base

    configure do 
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, ENV.fetch('SESSION_SECRET'){
            # SecureRandom.hex(64)
            "SAVE_OUTPUT_OF_ABOVE_AS_ENV_VARIABLE"
        }
    end

    get '/' do
        "Hello World"
    end

end