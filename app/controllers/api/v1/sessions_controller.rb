class Api::V1::SessionsController < Api::V1::BaseController
  before_action :require_api_login, only: :destroy

  def create
    user = User.find_for_database_authentication(email: params[:email].to_s.strip.downcase)

    if user&.valid_password?(params[:password])
      sign_in(user, store: false)
      render_success(data: session_payload(user))
    else
      render_error("Invalid email or password.", status: :unauthorized)
    end
  end

  def destroy
    current_user.regenerate_authentication_token!
    sign_out(current_user)

    render_success(data: { message: "Logged out successfully." })
  end

  private

  def session_payload(user)
    {
      token: user.authentication_token,
      user: {
        id: user.id,
        username: user.username,
        email: user.email,
        role: user.role
      }
    }
  end
end
