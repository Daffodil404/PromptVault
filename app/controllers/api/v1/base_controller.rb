class Api::V1::BaseController < ApplicationController
  skip_forgery_protection

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::ParameterMissing, with: :render_parameter_missing

  private

  def require_api_login
    return if logged_in?

    render_error("Authentication is required.", status: :unauthorized)
  end

  def require_api_owner(record, message)
    owner = record.respond_to?(:user) ? record.user : record
    return if owner == current_user

    render_error(message, status: :forbidden)
  end

  def render_success(data:, status: :ok)
    render json: { status: "success", data: data }, status: status
  end

  def render_errors(errors, status: :unprocessable_entity)
    render json: { status: "error", errors: Array(errors) }, status: status
  end

  def render_error(error, status: :unprocessable_entity)
    render_errors(error, status: status)
  end

  def render_not_found(exception)
    render_error(exception.message, status: :not_found)
  end

  def render_parameter_missing(exception)
    render_error(exception.message, status: :bad_request)
  end
end
