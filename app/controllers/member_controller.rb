class MemberController < ApplicationController

    get '/members/senate' do
        @pageinfo = {
            topic: "Current Senators",
            content: "Organized by state (more organization styles coming soon)"
        }
      
        @members = MemberAPI.all_senators
        @members.sort!{|a,b| a.state <=> b.state}
        erb :browse do 
            erb :"members/senator_card"
        end
    end

end