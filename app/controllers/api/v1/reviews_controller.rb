class Api::V1::ReviewsController < Api::V1::BaseController
  before_action :set_prompt
  before_action :set_review, only: [:update, :destroy]
  before_action :require_api_login, only: [:create, :update, :destroy]
  before_action :require_review_owner, only: [:update, :destroy]

  def index
    reviews = @prompt.reviews.includes(:user).order(created_at: :desc)
    render_success(data: reviews.map { |review| serialize_review(review) })
  end

  def create
    review = @prompt.reviews.new(review_params)
    review.user = current_user
    if review.save
      render_success(data: serialize_review(review), status: :created)
    else
      render_errors(review.errors.full_messages)
    end
  end

  def update
    if @review.update(review_params)
      render_success(data: serialize_review(@review))
    else
      render_errors(@review.errors.full_messages)
    end
  end

  def destroy
    @review.destroy
    render_success(data: { message: "Review deleted successfully." })
  end

  private

  def set_prompt
    @prompt = Prompt.find(params[:prompt_id])
  end

  def set_review
    @review = @prompt.reviews.find(params[:id])
  end

  def require_review_owner
    require_api_owner(@review, "You can only modify your own reviews.")
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end

  def serialize_review(review)
    {
      id: review.id,
      rating: review.rating,
      comment: review.comment,
      prompt_id: review.prompt_id,
      user_id: review.user_id,
      created_at: review.created_at,
      updated_at: review.updated_at,
      user: {
        id: review.user.id,
        username: review.user.username,
        email: review.user.email,
        role: review.user.role
      }
    }
  end
end
