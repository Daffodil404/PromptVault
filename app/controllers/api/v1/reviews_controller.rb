class Api::V1::ReviewsController < ApplicationController
  before_action :set_prompt
  before_action :set_review, only: [:update, :destroy]
  before_action :require_login, only: [:create, :update, :destroy]
  before_action :require_review_owner, only: [:update, :destroy]

  def index
    render json: @prompt.reviews
  end

  def create
    review = @prompt.reviews.new(review_params)
    review.user = current_user
    if review.save
      render json: review, status: :created
    else
      render json: {errors: review.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    if @review.update(review_params)
      render json: @review
    else
      render json: {errors: @review.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    head :no_content
  end

  private

  def set_prompt
    @prompt = Prompt.find(params[:prompt_id])
  end

  def set_review
    @review = @prompt.reviews.find(params[:id])
  end

  def require_review_owner
    require_owner(@review, "You can only modify your own reviews.")
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
