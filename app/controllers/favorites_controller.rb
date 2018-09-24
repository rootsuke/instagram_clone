class FavoritesController < ApplicationController

  def create
    @user = current_user
    @micropost = Micropost.find(params[:post_id])
    current_user.favorite(@micropost)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    @micropost = Favorite.find(params[:id]).favorite_post
    current_user.unfavorite(@micropost)
    redirect_back(fallback_location: root_path)
  end

end
