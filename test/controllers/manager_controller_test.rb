require 'test_helper'

class ManagerControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get manager_show_url
    assert_response :success
  end

end
