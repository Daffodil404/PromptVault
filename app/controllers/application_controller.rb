class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    return if logged_in?

    handle_access_denied("Please log in first.", :unauthorized)
  end

  def require_owner(record, message)
    return if record.user == current_user

    handle_access_denied(message, :forbidden)
  end

  def handle_access_denied(message, status)
    if request.format.json?
      render json: { error: message }, status: status
    else
      redirect_to login_path, alert: message if status == :unauthorized
      redirect_back fallback_location: root_path, alert: message if status == :forbidden
    end
  end
end
