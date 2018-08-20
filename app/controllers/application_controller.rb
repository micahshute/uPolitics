require './config/environment'

class ApplicationController < Sinatra::Base

    configure do
        set :public_folder, 'public'
        set :views, 'app/views'
        enable :sessions
        set :session_secret, ENV.fetch('SESSION_SECRET'){
            SecureRandom.hex(64)
            # "SAVE_OUTPUT_OF_ABOVE_AS_ENV_VARIABLE"
        }
    end

    get '/' do
      if not authorized?
        erb :"authenticate/index_newuser"
      else
        "Welcome, logged in user"
      end
    end


    helpers do

        def logged_in?
            !!session[:user_id]
        end

        def current_user
            User.find_by(id: session[:user_id])
        end

        def time_of_day
        hour = Time.now.to_s.split(" ")[1].split(":")[0].to_i
            if hour < 12
                "Morning"
            elsif hour < 17
                "Afternoon"
            else
                "Evening"
            end
        end

        def authorize
            if !logged_in? || current_user.nil?
                redirect '/login'
            end
        end

        def authorized?
            !!logged_in? && !current_user.nil?
        end

        def time_from_now(time)
            seconds = Time.now - time
            if seconds < 60
                return "#{seconds.to_i} seconds ago"
            elsif seconds < 3600
                return "#{(seconds / 60.0).to_i} minutes ago"
            elsif seconds < 86400
                return "#{(seconds / 3600.0).to_i} hours ago"
            elsif seconds < 604800
                return "#{(seconds / 86400.0).to_i} days ago"
            elsif seconds < 2419200
                return "#{(seconds / 604800.0).to_i} weeks ago"
            else
                return "on #{time}"
            end
        end

    end

end
