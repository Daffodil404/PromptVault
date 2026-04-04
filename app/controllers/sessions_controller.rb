class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_for_database_authentication(email: params[:email].to_s.strip.downcase)

    if user&.valid_password?(params[:password])
      sign_in(user)
      redirect_to root_path, notice: "Logged in successfully."
    else
      flash.now[:alert] = "Invalid email or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    sign_out(current_user) if user_signed_in?
    redirect_to login_path, notice: "Logged out successfully."
  end
end
