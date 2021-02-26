require "test_helper"

class GameControllerTest < ActionDispatch::IntegrationTest
  test "should get play" do
    get game_play_url
    assert_response :success
  end
end
