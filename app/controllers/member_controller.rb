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


    get '/members/senate/:member_slug' do
      if (mem = Member.find_by_slug_from(param: "member_identifier", slug: params[:member_slug]) || mem = MemberPlaceholder.new(member_identifier: params[:member_slug]))
        @member = MemberAPI.new_with_all_data(member: mem)
        erb :"members/show" do
          erb :"posts"
        end
      else
        erb :"errors/not_found"
      end
    end

end
