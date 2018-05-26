require 'test_helper'

class ApiControllerTest < ActionDispatch::IntegrationTest
  test "should get authenticate" do
    get api_authenticate_url
    assert_response :success
  end

  test "should get hashes" do
    get api_hashes_url
    assert_response :success
  end

  test "should get present" do
    get api_present_url
    assert_response :success
  end

end
