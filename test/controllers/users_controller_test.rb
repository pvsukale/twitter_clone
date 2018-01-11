require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should redirect index when not logged in" do
    get users_path
    assert_redirected_to login_url
  end

end
