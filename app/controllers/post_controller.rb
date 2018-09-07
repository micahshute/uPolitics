class PostController < ApplicationController

    post '/posts/:id/react' do
        authorize
        if post = Post.find_by(id: params[:id])
            undo = false
            user = current_user
            category = reaction(params: params)
            Reaction.all.each do |reaction|
                if reaction.user == user && reaction.reactable == post
                    undo = true if category == reaction.react_category_id
                    reaction.delete
                end
            end
            if not undo
                reaction = Reaction.new(react_category_id: category || 1)
                reaction.user = user
                reaction.reactable = post
                reaction.save
            end
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
            obj = post.postable
            redirect "#{obj.klass}s/senate/#{obj.slug_from("#{obj.klass}_identifier")}"
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