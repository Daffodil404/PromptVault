class PromptsController < ApplicationController
  before_action :set_prompt, only: %i[show edit update destroy]
  before_action :require_login, except: %i[index show]
  before_action :require_prompt_owner, only: %i[edit update destroy]

  def index
    @prompts = Prompt.includes(:user, :reviews).order(updated_at: :desc)
  end

  def show
    @prompt_versions = @prompt.prompt_versions.includes(:user).order(version_number: :desc)
    @reviews = @prompt.reviews.includes(:user).order(created_at: :desc)
  end

  def new
    @prompt = current_user.prompts.new(status: "draft")
  end

  def create
    @prompt = current_user.prompts.new(prompt_params)

    Prompt.transaction do
      @prompt.save!
      create_prompt_version!(@prompt, params.dig(:prompt, :change_note), "Initial version")
    end

    redirect_to @prompt, notice: "Prompt created successfully."
  rescue ActiveRecord::RecordInvalid => error
    attach_record_errors(error)
    render :new, status: :unprocessable_entity
  end

  def edit
  end

  def update
    Prompt.transaction do
      @prompt.update!(prompt_params)
      if @prompt.saved_change_to_content?
        create_prompt_version!(@prompt, params.dig(:prompt, :change_note), "Updated content")
      end
    end

    redirect_to @prompt, notice: "Prompt updated successfully."
  rescue ActiveRecord::RecordInvalid => error
    attach_record_errors(error)
    render :edit, status: :unprocessable_entity
  end

  def destroy
    @prompt.destroy
    redirect_to prompts_path, notice: "Prompt deleted successfully."
  end

  private

  def set_prompt
    @prompt = Prompt.find(params[:id])
  end

  def require_prompt_owner
    return if @prompt.user == current_user

    redirect_to @prompt, alert: "You can only edit your own prompts."
  end

  def prompt_params
    params.require(:prompt).permit(:title, :abstract, :content, :status)
  end

  def create_prompt_version!(prompt, change_note, default_note)
    prompt.prompt_versions.create!(
      version_number: prompt.prompt_versions.maximum(:version_number).to_i + 1,
      content: prompt.content,
      change_note: change_note.presence || default_note,
      user: current_user
    )
  end

  def attach_record_errors(error)
    return if error.record == @prompt

    @prompt.errors.add(:base, error.record.errors.full_messages.to_sentence)
  end
end
