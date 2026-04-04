require "test_helper"

class Api::V1::PromptVersionsControllerTest < ActionDispatch::IntegrationTest
  test "create uses the authenticated user instead of a submitted user_id" do
    assert_difference("PromptVersion.count", 1) do
      post "/api/v1/prompts/#{prompts(:one).id}/prompt_versions", params: {
        prompt_version: {
          version_number: 2,
          content: "Updated prompt content",
          change_note: "Clarified instructions",
          user_id: users(:two).id
        }
      }, headers: auth_headers(users(:one)), as: :json
    end

    assert_response :created
    assert_equal users(:one), PromptVersion.order(:id).last.user
  end

  private

  def auth_headers(user)
    { "Authorization" => "Bearer #{user.authentication_token}" }
  end
end
