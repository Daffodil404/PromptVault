class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update]
  before_action :require_login, only: [:edit, :update]
  before_action :require_user_owner, only: [:edit, :update]
  before_action :ensure_profile, only: [:show, :edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Account created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @recent_prompts = @user.prompts.includes(:tags).order(updated_at: :desc).limit(5)
    @reviewed_prompts = @user.reviewed_prompts.includes(:tags, :user).limit(5)
    @recent_reviews = @user.reviews.includes(:prompt).order(created_at: :desc).limit(5)
  end

  def edit
  end

  def update
    User.transaction do
      @user.update!(update_user_params)
      @profile.update!(profile_params)
    end

    redirect_to @user, notice: "Profile updated successfully."
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def ensure_profile
    @profile = @user.profile || @user.create_profile!
  end

  def require_user_owner
    require_owner(@user, "You can only edit your own profile.")
  end

  def user_params
    params.require(:user).permit(:username, :email, :role, :password, :password_confirmation)
  end

  def update_user_params
    params.require(:user).permit(:username, :email)
  end

  def profile_params
    params.dig(:user, :profile)&.permit(:bio, :location, :website, :favorite_prompt_style) ||
      params.fetch(:profile, {}).permit(:bio, :location, :website, :favorite_prompt_style)
  end
end
