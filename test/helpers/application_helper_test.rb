require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "check if page title is humanized" do
    assert_equal("Controller name", controller_name_as_page_title("controller_name"))
  end
end
