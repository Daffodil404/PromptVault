require "test_helper"

class Api::V1::RegistrationsControllerTest < ActionDispatch::IntegrationTest
  test "sign up creates a user and returns an API token" do
    assert_difference("User.count", 1) do
      post "/api/v1/auth/sign_up", params: {
        user: {
          username: "newuser",
          email: "newuser@example.com",
          password: "password",
          password_confirmation: "password",
          role: "author"
        }
      }, as: :json
    end

    assert_response :created

    response_data = JSON.parse(response.body)
    assert_equal "success", response_data["status"]
    assert_equal "newuser@example.com", response_data.dig("data", "user", "email")
    assert response_data.dig("data", "token").present?
  end
end
