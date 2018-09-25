class MemberController < ApplicationController

    get '/members/senate' do
        authorize
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
      authorize
      if (mem = Member.find_by_slug_from(param: "member_identifier", slug: params[:member_slug]) || mem = MemberPlaceholder.new(member_identifier: params[:member_slug]))
        @member = MemberAPI.new_with_all_data(member: mem)
        erb :"members/show" do
          erb :"posts"
        end
      else
        erb :"errors/not_found"
      end
    end

    post '/members/senate/:member_slug/follow' do
        authorize
        member = Member.find_or_create_by(member_identifier: params[:member_slug])
        user = current_user
        user.followed_members << member
        user.save
        redirect "members/senate/#{member.member_identifier}"
    end

    post '/members/senate/:member_slug/unfollow' do
        authorize
        member = Member.find_or_create_by(member_identifier: params[:member_slug])
        user = current_user
        user.followed_members = user.followed_members.reject{|m| m.member_identifier == member.member_identifier}
        user.save
        redirect "members/senate/#{member.member_identifier}"
    end

    post '/members/senate/:member_slug/react' do
      authorize
      if member = Member.find_or_create_by(member_identifier: params[:member_slug])
          undo = false
          user = current_user
          category = reaction(params: params)
          Reaction.all.each do |reaction|
              if reaction.user == user && reaction.reactable == member
                  undo = true if category == reaction.react_category_id
                  reaction.delete
              end
          end
          if not undo
              reaction = Reaction.new(react_category_id: category)
              reaction.user = user
              reaction.reactable = member
              reaction.save
          end
          redirect "members/senate/#{member.member_identifier}"
      else
          erb :"errors/not_found"
      end

    end

    post '/members/senate/:member_slug/posts/new' do
        authorize
        member = Member.find_or_create_by(member_identifier: params[:member_slug])
        user = current_user
        params[:post][:content] = Sanitize.fragment(params[:post][:content])
        post = Post.new(params[:post])
        post.user = user
        post.postable = member
        post.save
        redirect "/members/senate/#{member.member_identifier}"
    end

end
