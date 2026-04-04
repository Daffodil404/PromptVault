require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "welcome_email" do
    mail = UserMailer.welcome_email(users(:one))

    assert_equal ["alice@example.com"], mail.to
    assert_equal ["no-reply@promptvault.local"], mail.from
    assert_equal "Welcome to PromptVault", mail.subject
    assert_includes mail.body.encoded, "Welcome to PromptVault, alice!"
  end
end
