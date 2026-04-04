class Api::V1::PromptsController < Api::V1::BaseController
  before_action :set_prompt, only: [:show, :update, :destroy]
  before_action :require_api_login, only: [:create, :update, :destroy]
  before_action :require_prompt_owner, only: [:update, :destroy]

  def index
    prompts = Prompt.includes(:user, :prompt_versions, :reviews, :tags).order(updated_at: :desc)
    render_success(data: prompts.map { |prompt| serialize_prompt(prompt) })
  end

  def show
    render_success(data: serialize_prompt(@prompt))
  end

  def create
    prompt = current_user.prompts.new(prompt_attributes)

    Prompt.transaction do
      prompt.save!
      prompt.sync_tags_from_names!(tag_names_param)
    end

    render_success(data: serialize_prompt(prompt.reload), status: :created)
  rescue ActiveRecord::RecordInvalid => error
    render_errors(error.record.errors.full_messages)
  end

  def update
    Prompt.transaction do
      @prompt.update!(prompt_attributes)
      @prompt.sync_tags_from_names!(tag_names_param)
    end

    render_success(data: serialize_prompt(@prompt.reload))
  rescue ActiveRecord::RecordInvalid => error
    render_errors(error.record.errors.full_messages)
  end

  def destroy
    @prompt.destroy
    render_success(data: { message: "Prompt deleted successfully." })
  end

  private

  def set_prompt
    @prompt = Prompt.find(params[:id])
  end

  def require_prompt_owner
    require_api_owner(@prompt, "You can only modify your own prompts.")
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

  def serialize_prompt(prompt)
    {
      id: prompt.id,
      title: prompt.title,
      abstract: prompt.abstract,
      content: prompt.content,
      status: prompt.status,
      created_at: prompt.created_at,
      updated_at: prompt.updated_at,
      user: serialize_user_summary(prompt.user),
      prompt_versions: prompt.prompt_versions.order(version_number: :desc).map { |version| serialize_prompt_version(version) },
      reviews: prompt.reviews.order(created_at: :desc).map { |review| serialize_review(review) },
      tags: prompt.tags.order(:name).map { |tag| { id: tag.id, name: tag.name } }
    }
  end

  def serialize_user_summary(user)
    {
      id: user.id,
      username: user.username,
      email: user.email,
      role: user.role
    }
  end

  def serialize_prompt_version(version)
    {
      id: version.id,
      version_number: version.version_number,
      content: version.content,
      change_note: version.change_note,
      user_id: version.user_id,
      created_at: version.created_at,
      updated_at: version.updated_at
    }
  end

  def serialize_review(review)
    {
      id: review.id,
      rating: review.rating,
      comment: review.comment,
      user_id: review.user_id,
      prompt_id: review.prompt_id,
      created_at: review.created_at,
      updated_at: review.updated_at
    }
  end
end
