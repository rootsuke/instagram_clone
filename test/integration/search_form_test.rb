require 'test_helper'

class SearchFormTest <ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @micropost = microposts(:orange)
    log_in_as @user
  end

  test "show search result" do
    get microposts_path, params: {search: "orange"}
    assert_template "microposts/index"
    assert_equal 3, assigns(:microposts).count
    assert_match assigns(:microposts).count.to_s, response.body
    assert flash.any?
  end

  test "wrong search form param" do
    get microposts_path, params: {search: ""}
    assert_redirected_to root_url
    assert flash.any?
    get microposts_path, params: {search: " "}
    assert_redirected_to root_url
  end
end
