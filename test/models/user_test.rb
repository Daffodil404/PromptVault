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

  test "exposes reviewed prompts through reviews" do
    assert_includes users(:one).reviewed_prompts, prompts(:one)
  end
end
