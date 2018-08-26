require 'test_helper'

class SubcriptionsControllerTest < ActionDispatch::IntegrationTest
  test "should get upgrade" do
    get subcriptions_upgrade_url
    assert_response :success
  end

end
