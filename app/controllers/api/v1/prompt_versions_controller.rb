class Api::V1::PromptVersionsController < ApplicationController
  before_action :set_prompt
  def index
    render json: @prompt.prompt_versions
  end

  def show
    prompt_version = @prompt.prompt_versions.find(params[:id])
    render json: prompt_version
  end

  def create
    prompt_version = @prompt.prompt_versions.new(prompt_version_params)

    if prompt_version.save
      render json: prompt_version, status: :created
    else
      render json: {errors: prompt_version.errors.full_messages}, status: :unprocessable_entity
    end
  end

  private
  def set_prompt
    @prompt = Prompt.find(params[:prompt_id])
  end

  def prompt_version_params
    params.require(:prompt_version).permit(:version_number, :content, :change_note, :user_id)
  end
end
