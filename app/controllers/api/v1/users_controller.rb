class Api::V1::UsersController < ApplicationController
  def show
    user = User.includes(:profile, :prompts, :reviewed_prompts, :reviews).find(params[:id])

    render json: user.as_json(
      only: [:id, :username, :email, :role],
      include: {
        profile: { only: [:bio, :location, :website, :favorite_prompt_style] },
        prompts: { only: [:id, :title, :status] },
        reviewed_prompts: { only: [:id, :title, :status] },
        reviews: { only: [:id, :prompt_id, :rating, :comment] }
      }
    )
  end
end
