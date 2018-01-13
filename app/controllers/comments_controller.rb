class CommentsController < ApplicationController

    before_action :logged_in_user, only: [:create , :destroy]
    def create
        @comment = Comment.new
        
    
        @micropost = Micropost.find(params[:micropost])
        @comment.user = current_user
        @comment.micropost = @micropost
        @comment.content = params[:comment][:content]
     
        if @comment.save 
            redirect_to micropost_path(@micropost)
        else
            render 'microposts/show'
        end
       
        
    end

    def destroy
        @comment = Comment.find(params[:id])
        if current_user == @comment.user or current_user == @comment.micropost.user
            @comment.destroy
            flash[:success] = "Micropost deleted"
            redirect_to request.referrer || root_url
        else
            flash[:success] = "You are not supposed to do this"
            redirect_to request.referrer || root_url
        end
    end
end
