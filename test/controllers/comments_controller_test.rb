require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @comment = comments(:orange_comment)
  end

  test "should redirect create when not logged in" do
    assert_no_difference "Comment.count" do
      post comments_path, params: {comment: {content: "go"}}
    end
    assert_redirected_to login_url
  end

end
