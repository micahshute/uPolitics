class BillController < ApplicationController

    get '/bills/senate/recent/active' do
        @bills = APIManager.transform_recent_bills_data(type: "active", chamber: "senate") do |data|
            BillAPI.new_from_data(data)
        end
        @pageinfo = {
            topic: "Recent Active Bills in the Senate",
            content: "Browse bills being discussed now!"
        }
        erb :browse do 
            erb :"bills/bill_card"
        end
    end

    get '/bills/senate/recent/introduced' do
        @bills = APIManager.transform_recent_bills_data(type: "introduced", chamber: "senate") do |data|
            BillAPI.new_from_data(data)
        end
        @pageinfo = {
            topic: "Recent Introduced Bills in the Senate",
            content: "Browse bills being introduced now!"
        }
        erb :browse do 
            erb :"bills/bill_card"
        end
    end

    get '/bills/senate/recent/passed' do
        @bills = APIManager.transform_recent_bills_data(type: "passed", chamber: "senate") do |data|
            BillAPI.new_from_data(data)
        end
        @pageinfo = {
            topic: "Recently Passed Bills in the Senate",
            content: "Browse bills have just become law!"
        }
        erb :browse do 
            erb :"bills/bill_card"
        end
    end

    get '/bills/senate/recent/vetoed' do
        @bills = APIManager.transform_recent_bills_data(type: "vetoed", chamber: "senate") do |data|
            BillAPI.new_from_data(data)
        end
        @pageinfo = {
            topic: "Recently Vetoed Bills",
            content: "Browse bills have just been vetoed!"
        }
        erb :browse do 
            erb :"bills/bill_card"
        end
    end


    get '/bills/senate/:bill_slug' do 
        bill_base = Bill.find_by_slug_from(param: "bill_identifier", slug: params[:bill_slug]) || BillPlaceholder.new(bill_identifier: params[:bill_slug])
        @bill = BillAPI.new(bill: bill_base)
        
        erb :"bills/show" do erb :"posts" end
    end

    post '/bills/senate/:bill_slug/follow' do
        authorize
        bill = Bill.find_or_create_by(bill_identifier: params[:bill_slug], congress: 115)
        user = current_user
        user.followed_bills << bill
        user.save
        redirect "bills/senate/#{bill.bill_identifier}"
    end

    post '/bills/senate/:bill_slug/unfollow' do
        authorize
        bill = Bill.find_or_create_by(bill_identifier: params[:bill_slug], congress: 115)
        user = current_user
        user.followed_bills = user.followed_bills.reject{|b| b.bill_identifier == bill.bill_identifier}
        user.save
        redirect "bills/senate/#{bill.bill_identifier}"
    end

    post '/bills/senate/:bill_slug/react' do
        authorize
        bill = Bill.find_or_create_by(bill_identifier: params[:bill_slug], congress: 115)
        user = current_user
        category = reaction(params: params)
        Reaction.all.each do |reaction|
            if reaction.user == user && reaction.reactable == bill
                reaction.delete
            end
        end
        reaction = Reaction.new(react_category_id: category)
        reaction.user = user
        reaction.reactable = bill
        reaction.save
        redirect "bills/senate/#{bill.bill_identifier}"
    end

    post '/bills/senate/:bill_slug/posts/new' do
        authorize
        bill = Bill.find_or_create_by(bill_identifier: params[:bill_slug], congress: 115)
        user = current_user
        post = Post.new(params[:post])
        post.user = user
        post.postable = bill
        post.save
        redirect "/bills/senate/#{bill.bill_identifier}"
    end

    post '/posts/:id/react' do
        authorize
        if post = Post.find_by(id: params[:id])
            user = current_user
            category = reaction(params: params)
            Reaction.all.each do |reaction|
                if reaction.user == user && reaction.reactable == post
                    reaction.delete
                end
            end
            reaction = Reaction.new(react_category_id: category)
            reaction.user = user
            reaction.reactable = post
            reaction.save
            obj = post.postable
            redirect "#{obj.klass}s/senate/#{obj.slug_from("#{obj.klass}_identifier")}"
        else
            erb :"errors/not_found"
        end
    end

    get '/posts/:id/edit' do
        authorize
        if @post = Post.find_by(id: params[:id])
            redirect '/logout' if !current_user.posts.include?(@post)
            erb :"posts/edit"
        else
            erb :"errors/not_found"
        end
    end

    patch '/posts/:id' do
        authorize
        if post = Post.find_by(id: params[:id])
            redirect '/logout' if !current_user.posts.include?(post)
            post.update(params[:post])
        else
            erb :"errors/not_found"
        end
    end

    delete '/posts/:id/delete' do
        authorize
        if post = Post.find_by(id: params[:id])
            redirect '/logout' if !current_user.posts.include?(post)
            obj = post.postable
            post.delete
            redirect "/#{obj.klass}s/senate/#{obj.slug_from("#{obj.klass}_identifier")}"
        else
            erb :"errors/not_found"
        end

    end




end