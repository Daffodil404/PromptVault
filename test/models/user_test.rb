require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "creates a profile after user creation" do
    user = User.create!(
      username: "profile_owner",
      email: "profile_owner@example.com",
      role: "author",
      password: "password",
      password_confirmation: "password"
    )

    assert_predicate user.profile, :present?
  end

  test "queues a welcome email after create" do
    assert_enqueued_emails 1 do
      User.create!(
        username: "welcome_owner",
        email: "welcome_owner@example.com",
        role: "author",
        password: "password",
        password_confirmation: "password"
      )
    end
  end

  test "generates an authentication token on create" do
    user = User.create!(
      username: "token_owner",
      email: "token_owner@example.com",
      role: "author",
      password: "password",
      password_confirmation: "password"
    )

    assert_predicate user.authentication_token, :present?
  end

  test "exposes reviewed prompts through reviews" do
    assert_includes users(:one).reviewed_prompts, prompts(:one)
  end
end
