require "test_helper"

class Api::V1::PromptsControllerTest < ActionDispatch::IntegrationTest
  test "create requires authentication" do
    post "/api/v1/prompts", params: {
      prompt: {
        title: "Tokenless prompt",
        abstract: "Should be rejected",
        content: "No token provided",
        status: "draft"
      }
    }, as: :json

    assert_response :unauthorized
  end
end
