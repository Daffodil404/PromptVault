require "test_helper"

class Api::V1::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "login returns the user's API token" do
    post "/api/v1/auth/login", params: {
      email: users(:one).email,
      password: "password"
    }, as: :json

    assert_response :success

    response_data = JSON.parse(response.body)
    assert_equal users(:one).authentication_token, response_data.dig("data", "token")
    assert_equal users(:one).email, response_data.dig("data", "user", "email")
  end

  test "logout rotates the API token" do
    original_token = users(:one).authentication_token

    delete "/api/v1/auth/logout", headers: auth_headers(users(:one)), as: :json

    assert_response :success
    assert_not_equal original_token, users(:one).reload.authentication_token
  end

  private

  def auth_headers(user)
    { "Authorization" => "Bearer #{user.authentication_token}" }
  end
end
