class CommentsController < ApplicationController

  before_action :logged_in_user

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.micropost_id = params[:post_id]

    if @comment.save
      flash[:success] = "コメントを送信しました"
      @user = @comment.micropost.user
      @user.notifications.create(notified_by_id: current_user.id,
                          micropost_id: params[:post_id], notification_type: "comment")
      redirect_to request.referrer || root_url
    else
      if @comment.content.blank?
        flash.now[:danger]= "コメントを入力してください"
      elsif @comment.content.length > 140
        flash.now[:danger]= "コメントが長すぎます"
      end
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
      render "static_pages/home"
    end

  end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end
end
