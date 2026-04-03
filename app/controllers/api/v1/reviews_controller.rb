class Api::V1::ReviewsController < ApplicationController
  before_action :set_prompt
  def index
    render json: @prompt.reviews
  end

  def create
    review = @prompt.reviews.new(review_params)
    if review.save
      render json: review, status: :created
    else
      render json: {errors: review.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private
  def set_prompt
    @prompt = Prompt.find(params[:prompt_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment, :user_id)
  end
end
