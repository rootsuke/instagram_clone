require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test "profile display" do
    log_in_as @user
    get user_path(@user)
    assert_template 'users/show'
    @user.follow(@other_user)
    assert_match @user.active_relationships.count.to_s, response.body
    assert_match @user.passive_relationships.count.to_s, response.body
    assert_select 'title', full_title(@user.name)
    assert_match @user.microposts.count.to_s, response.body
  end

end
