class CommentsController < ApplicationController
  before_action :logged_in_user

  def create
    @comment = current_user.comments.build(comment_params)
    @comment.micropost_id = params[:post_id]

    if @comment.save
      flash[:success] = "コメントを送信しました"
      @user = @comment.micropost.user
      @user.notifications.create(notified_by_id: current_user.id,
                                 micropost_id: params[:post_id],
                                 notification_type: "comment")
      redirect_to micropost_path(@comment.micropost)
    else
      if @comment.content.blank?
        flash[:danger] = "コメントを入力してください"
      elsif @comment.content.length > 140
        flash[:danger] = "コメントが長すぎます"
      end
      @micropost = Micropost.find(params[:post_id])
      redirect_to micropost_path(@micropost)
    end
  end

  private

    def comment_params
      params.require(:comment).permit(:content)
    end
end
