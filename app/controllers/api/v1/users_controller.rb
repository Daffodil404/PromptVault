class Api::V1::UsersController < Api::V1::BaseController
  def show
    user = User.includes(:profile, :prompts, :reviewed_prompts, :reviews).find(params[:id])

    render_success(
      data: {
        id: user.id,
        username: user.username,
        email: user.email,
        role: user.role,
        profile: {
          bio: user.profile&.bio,
          location: user.profile&.location,
          website: user.profile&.website,
          favorite_prompt_style: user.profile&.favorite_prompt_style
        },
        prompts: user.prompts.order(updated_at: :desc).map { |prompt| { id: prompt.id, title: prompt.title, status: prompt.status } },
        reviewed_prompts: user.reviewed_prompts.distinct.order(updated_at: :desc).map { |prompt| { id: prompt.id, title: prompt.title, status: prompt.status } },
        reviews: user.reviews.order(created_at: :desc).map { |review| { id: review.id, prompt_id: review.prompt_id, rating: review.rating, comment: review.comment } }
      }
    )
  end
end
