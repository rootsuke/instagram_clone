require 'test_helper'

class NotificationsTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @micropost = microposts(:cat_video)
    log_in_as @user
  end

  test "favorite notification should be unique" do
    # 初めてお気に入りしたときは通知する
    assert_difference "@other_user.notifications.count", 1 do
      post favorites_path(params: {post_id: @micropost.id})
    end
    @user.unfavorite @micropost
    # ２回目以降のお気に入りでは通知しない
    assert_no_difference "@other_user.notifications.count" do
      post favorites_path(params: {post_id: @micropost.id})
    end
  end

  test "favorite notification should be unique with Ajax" do
    # 初めてお気に入りしたときは通知する
    assert_difference "@other_user.notifications.count", 1 do
      post favorites_path(params: {post_id: @micropost.id}, xhr: true)
    end
    @user.unfavorite @micropost
    # ２回目以降のお気に入りでは通知しない
    assert_no_difference "@other_user.notifications.count" do
      post favorites_path(params: {post_id: @micropost.id}, xhr: true)
    end
  end

  test "follow notification should be unique" do
    # 初めてフォローしたときは通知する
    assert_difference "@other_user.notifications.count", 1 do
      post relationships_path, params: {followed_id: @other_user.id}
    end
    @user.unfollow @other_user
    # ２回目以降のフォローでは通知しない
    assert_no_difference "@other_user.notifications.count" do
      post relationships_path, params: {followed_id: @other_user.id}
    end
  end

  test "follow notification should be unique with Ajax" do
    # 初めてフォローしたときは通知する
    assert_difference "@other_user.notifications.count", 1 do
      post relationships_path, xhr: true, params: {followed_id: @other_user.id}
    end
    @user.unfollow @other_user
    # ２回目以降のフォローでは通知しない
    assert_no_difference "@other_user.notifications.count" do
      post relationships_path, xhr: true, params: {followed_id: @other_user.id}
    end
  end

end
