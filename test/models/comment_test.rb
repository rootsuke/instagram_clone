require 'test_helper'

class CommentTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @micropost = microposts(:orange)
    @comment = @user.comments.build(content: "go", micropost: @micropost)
  end

  test "should be valid" do
    assert @comment.valid?
  end

  test "user_id should be present" do
    @comment.user_id = nil
    assert_not @comment.valid?
  end

  test "content should be presence and max 140 char" do
    @comment.content = nil
    assert_not @comment.valid?
    @comment.content = "a"*141
    assert_not @comment.valid?
  end

  test "most recent comment should be first" do
    assert_equal comments(:oldest_comment), Comment.first
  end


end
