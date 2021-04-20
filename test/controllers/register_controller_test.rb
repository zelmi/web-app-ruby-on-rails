require 'test_helper'

class RegisterControllerTest < ActionDispatch::IntegrationTest
  test "should get login" do
    get register_login_url
    assert_response :success
  end

  test "should get logout" do
    get register_logout_url
    assert_response :success
  end

  test "should get create" do
    get register_create_url
    assert_response :success
  end

  test "should get handle_login" do
    get register_handle_login_url
    assert_response :success
  end

end
