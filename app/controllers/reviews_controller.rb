class ReviewsController < ApplicationController
  before_action :set_prompt
  before_action :set_review, only: %i[edit update destroy]
  before_action :require_login, except: :index
  before_action :require_review_owner, only: %i[edit update destroy]

  def index
    @reviews = @prompt.reviews.includes(:user).order(created_at: :desc)
  end

  def new
    @review = @prompt.reviews.new
  end

  def create
    @review = @prompt.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to prompt_path(@prompt), notice: "Review added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @review.update(review_params)
      redirect_to prompt_path(@prompt), notice: "Review updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    redirect_to prompt_path(@prompt), notice: "Review deleted successfully."
  end

  private

  def set_prompt
    @prompt = Prompt.find(params[:prompt_id])
  end

  def set_review
    @review = @prompt.reviews.find(params[:id])
  end

  def require_review_owner
    return if @review.user == current_user

    redirect_to prompt_path(@prompt), alert: "You can only edit your own reviews."
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
