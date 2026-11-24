require "test_helper"

class FavsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get favs_index_url
    assert_response :success
  end

  test "should get create" do
    get favs_create_url
    assert_response :success
  end

  test "should get show" do
    get favs_show_url
    assert_response :success
  end

  test "should get destroy" do
    get favs_destroy_url
    assert_response :success
  end
end
