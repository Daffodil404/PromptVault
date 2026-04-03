class Api::V1::PromptsController < ApplicationController
  before_action :set_prompt, only: [:show, :update, :destroy]
  before_action :require_login, only: [:create, :update, :destroy]
  before_action :require_prompt_owner, only: [:update, :destroy]
  def index
    prompts = Prompt.includes(:user, :prompt_versions, :reviews, :tags).all
    render json: prompts.as_json(include: prompt_includes)
  end

  def show
    render json: @prompt.as_json(include: prompt_includes)
  end

  def create
    prompt = current_user.prompts.new(prompt_attributes)

    Prompt.transaction do
      prompt.save!
      prompt.sync_tags_from_names!(tag_names_param)
    end

    render json: prompt.as_json(include: prompt_includes), status: :created
  rescue ActiveRecord::RecordInvalid => error
    render json: { errors: error.record.errors.full_messages }, status: :unprocessable_entity
  end

  def update
    Prompt.transaction do
      @prompt.update!(prompt_attributes)
      @prompt.sync_tags_from_names!(tag_names_param)
    end

    render json: @prompt.as_json(include: prompt_includes)
  rescue ActiveRecord::RecordInvalid => error
    render json: { errors: error.record.errors.full_messages }, status: :unprocessable_entity
  end

  def destroy
    @prompt.destroy
    head :no_content
  end

  private

  def set_prompt
    @prompt = Prompt.find(params[:id])
  end

  def require_prompt_owner
    require_owner(@prompt, "You can only modify your own prompts.")
  end

  def prompt_params
    params.require(:prompt).permit(:title, :abstract, :content, :status, :tag_names)
  end

  def prompt_attributes
    prompt_params.to_h.except("tag_names")
  end

  def tag_names_param
    prompt_params[:tag_names]
  end

  def prompt_includes
    {
      user: { only: [:id, :username, :email, :role] },
      prompt_versions: { only: [:id, :version_number, :content, :change_note, :user_id] },
      reviews: { only: [:id, :rating, :comment, :user_id] },
      tags: { only: [:id, :name] }
    }
  end
end
