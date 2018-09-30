require 'test_helper'

class CommentsTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
    @micropost = microposts(:cat_video)
    log_in_as @user
  end

  test "should post comment and send notification" do
    @user.follow(@other_user)
    assert_no_difference "@user.comments.count" do
      assert_no_difference "@other_user.notifications.count" do
        post comments_path, params: {post_id: @micropost.id, comment: {content: " "}}
      end
    end
    content = "correct params"
    assert_difference "@user.comments.count", 1 do
      assert_difference "@other_user.notifications.count", 1 do
        post comments_path, params: {post_id: @micropost.id, comment: {content: content}}
      end
    end
    follow_redirect!
    assert_match content, response.body
  end
end
