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
        @user = UserAPIDecorator.new(user: current_user)
        site_down if @user.nil?
        erb :"users/index"
      end
    end

    get '/sitedown' do
        erb :"errors/site_down"
    end


    get '/logout' do
        session.clear
        redirect '/'
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

        def authorize_slug(slug)
            authorize
            redirect '/' if current_user.slug != slug
        end

        def site_down
            redirect '/sitedown'
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

        def parse_date(date)
            data = date.split('-')
            year = data[0]
            month = data[1]
            day = data[2]
            "#{month}/#{day}/#{year}"
        end

        def reaction_to_member(id:)
           

        end

        def reaction(params:)
            if params.keys.include?("like")
                return 1
            elsif
                params.keys.include?("dislike")
                return 0
            else
                return nil
            end
        end

        def reaction_to_committee(id:)
            
        end

        def num_likes(react_arr)
            react_arr.select{|r| r.react_category_id == 1}.length
        end

        def num_dislikes(react_arr)
            react_arr.select{|r| r.react_category_id == 0}.length
        end

        def reaction_to_bill(id:)
            if (reaction = current_user.reactions.find{|r| r.reactable && r.reactable.klass == "bill" && r.reactable.bill_identifier == id }) && !reaction.nil?
                case reaction.react_category_id
                when 0
                    "dislike"
                when 1
                    "like"
                end
            else
                return nil
            end
        end

        def reaction_to_post(id:)
            if (reaction = current_user.reactions.find{|r| r.reactable && r.reactable.klass == "post" && r.reactable.id == id }) && !reaction.nil?
                case reaction.react_category_id
                when 0
                    "dislike"
                when 1
                    "like"
                end
            else
                return nil
            end
        end

       

        def member_followed?(id:)
            !!current_user.followed_members.find{|mem| mem.member_identifier == id}
        end

        def committee_followed?(id:)
            !!current_user.followed_committees.find{|c| c.committee_identifier == id}
        end

        def bill_followed?(id:)
            !!current_user.followed_bills.find{|bill| bill.bill_identifier == id}
        end
        

    end

end
