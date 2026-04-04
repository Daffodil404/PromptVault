class ApplicationMailer < ActionMailer::Base
  default from: -> { Rails.application.credentials.dig(:smtp, :user_name) || "no-reply@promptvault.local" }
  layout "mailer"
end
