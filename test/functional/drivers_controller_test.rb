require 'test_helper'

class DriversControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get claim" do
    get :claim
    assert_response :success
  end

end
