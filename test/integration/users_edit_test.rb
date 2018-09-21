require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template "users/edit"
    patch user_path(@user), params: {user: {name: "", email: "foo@invalid"}}
    assert_template "users/edit"
    assert_select "div.alert", "The form contains 2 errors."
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    follow_redirect!
    assert_template "users/edit"
    name = "foo bar"
    email = "foobar@foobar.com"
    patch user_path(@user), params: {user: {name: name, email: email,
                                            password: "", password_confirmation: ""}}
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

end
