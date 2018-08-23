class MemberController < ApplicationController

    get '/members/senate' do
        @pageinfo = {
            topic: "Current Senators",
            content: "Organized by name (more organization styles coming soon)"
        }
      
        @members = MemberAPI.all_senators

        erb :browse do 
            erb :"members/senator_card"
        end
    end

end