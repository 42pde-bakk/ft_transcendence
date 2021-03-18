require "test_helper"

class GuildsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get guilds_index_url
    assert_response :success
  end
end
