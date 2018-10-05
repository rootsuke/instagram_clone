require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @micropost = microposts(:orange)
  end

  test "should redirect create when not logged in" do
    assert_no_difference "Micropost.count" do
      post microposts_path, params: {micropost: {content: "matsumu go"}}
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference "Micropost.count" do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy for wrong micropost" do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference "Micropost.count" do
      delete micropost_path(micropost)
    end
    assert_redirected_to root_url
  end

  test "should render show page" do
    log_in_as(users(:michael))
    get micropost_path(@micropost)
    assert_template "microposts/show"
    assert_match @micropost.content, response.body
  end

end
