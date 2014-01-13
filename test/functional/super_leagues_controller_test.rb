require 'test_helper'

class SuperLeaguesControllerTest < ActionController::TestCase
  test "should get show" do
    get :show
    assert_response :success
  end

end
