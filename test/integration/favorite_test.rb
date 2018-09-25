require 'test_helper'

class FavoriteTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @micropost = microposts(:orange)
    log_in_as @user
  end

  test "favorites page" do
    get favorites_user_path(@user)
    assert @user.favorite_posts.any?
    assert_match @user.favorite_posts.count.to_s, response.body
    assert_select "a[data-method=?]", "post", count: 0
  end

  test "should favorite a micropost" do
    assert_difference "@user.favorite_posts.count", 1 do
      post favorites_path(params: {post_id: @micropost.id})
    end
  end

  test "should unfavorite a micropost" do
    @user.favorite(@micropost)
    favorite = Favorite.find_by(favorite_post_id: @micropost.id)
    assert_difference "@user.favorite_posts.count", -1 do
      delete favorite_path(favorite)
    end
  end

  test "should favorite a micropost with Ajax" do
    assert_difference "@user.favorite_posts.count", 1 do
      post favorites_path(params: {post_id: @micropost.id}, xhr: true)
    end
  end

  test "should unfavorite a micropost with Ajax" do
    @user.favorite(@micropost)
    favorite = Favorite.find_by(favorite_post_id: @micropost.id)
    assert_difference "@user.favorite_posts.count", -1 do
      delete favorite_path(favorite, xhr: true)
    end
  end

end
