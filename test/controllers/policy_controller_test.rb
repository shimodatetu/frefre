require 'test_helper'

class PolicyControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get policy_new_url
    assert_response :success
  end

end
