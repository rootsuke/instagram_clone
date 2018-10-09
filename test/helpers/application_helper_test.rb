require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title, "Instagram_clone"
    assert_equal full_title("Agreement"), "Agreement | Instagram_clone"
  end
end
