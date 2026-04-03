class Api::V1::PromptsController < ApplicationController
  before_action :set_prompt, only: [:show, :update, :destroy]
  def index
    prompts = Prompt.includes(:user, :prompt_versions, :reviews).all
    render json: prompts.as_json(
      include:{
        user: {only:[:id, :username, :email, :role]},
        prompt_versions:{only:[:id,:version_nummber,:content,:change_note,:user_id]},
        reviews:{only:[:id, :rating,:comment,:user_id]},
      }
    )
  end

  def show
    render json: @prompt.as_json(
      include:{
        user: {only:[:id,:username,:email,:role]},
        prompt_versions:{only:[:id,:version_nummber,:content,:change_note,:user_id]},
        reviews:{only:[:id, :rating,:comment,:user_id]},
      }
    )
  end

  def create
    prompt = Prompt.new(prompt_params)
    if prompt.save
      render json: prompt, status: :created
    else
      render json: {errors: prompt.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    if @prompt.update(prompt_params)
      render json: @prompt
    else
      render json: {errors: @prompt.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    @prompt.destroy
    head :no_content
  end

  private
  def set_prompt
    @prompt = Prompt.find(params[:id])
  end

  def prompt_params
    params.require(:prompt).permit(:title, :abstract, :content, :status, :user_id)
  end
end
