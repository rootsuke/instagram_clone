class FavoritesController < ApplicationController

  before_action :logged_in_user

  def create
    @micropost = Micropost.find(params[:post_id])
    current_user.favorite(@micropost)
    Notification.create(user_id: @micropost.user_id, notified_by_id: current_user.id,
                        notification_type: "favorite")
    respond_to do |format|
      format.html {redirect_back(fallback_location: root_path)}
      format.js
    end
  end

  def destroy
    @micropost = Favorite.find(params[:id]).favorite_post
    current_user.unfavorite(@micropost)
    respond_to do |format|
      format.html {redirect_back(fallback_location: root_path)}
      format.js
    end
  end

end
