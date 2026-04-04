class Api::V1::RegistrationsController < Api::V1::BaseController
  def create
    user = User.new(sign_up_params)

    if user.save
      sign_in(user, store: false)
      render_success(data: registration_payload(user), status: :created)
    else
      render_errors(user.errors.full_messages)
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :role)
  end

  def registration_payload(user)
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
