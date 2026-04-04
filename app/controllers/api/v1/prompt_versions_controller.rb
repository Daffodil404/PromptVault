class Api::V1::PromptVersionsController < Api::V1::BaseController
  before_action :set_prompt

  def index
    versions = @prompt.prompt_versions.includes(:user).order(version_number: :desc)
    render_success(data: versions.map { |version| serialize_prompt_version(version) })
  end

  def show
    prompt_version = @prompt.prompt_versions.find(params[:id])
    render_success(data: serialize_prompt_version(prompt_version))
  end

  def create
    prompt_version = @prompt.prompt_versions.new(prompt_version_params)

    if prompt_version.save
      render_success(data: serialize_prompt_version(prompt_version), status: :created)
    else
      render_errors(prompt_version.errors.full_messages)
    end
  end

  private

  def set_prompt
    @prompt = Prompt.find(params[:prompt_id])
  end

  def prompt_version_params
    params.require(:prompt_version).permit(:version_number, :content, :change_note, :user_id)
  end

  def serialize_prompt_version(prompt_version)
    {
      id: prompt_version.id,
      version_number: prompt_version.version_number,
      content: prompt_version.content,
      change_note: prompt_version.change_note,
      prompt_id: prompt_version.prompt_id,
      user_id: prompt_version.user_id,
      created_at: prompt_version.created_at,
      updated_at: prompt_version.updated_at,
      user: {
        id: prompt_version.user.id,
        username: prompt_version.user.username,
        email: prompt_version.user.email,
        role: prompt_version.user.role
      }
    }
  end
end
