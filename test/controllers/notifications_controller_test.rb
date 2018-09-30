require 'test_helper'

class NotificationsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
    log_in_as @user
  end

  test "reset unread notifications" do
    assert @user.has_unread_notifications?
    get notifications_path
    assert_not @user.has_unread_notifications?
  end

end
