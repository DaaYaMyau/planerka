class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :teaser_gate, if: -> { Rails.configuration.x.teaser }

  rescue_from CanCan::AccessDenied do
    if user_signed_in?
      redirect_to root_path, alert: "У вас нет доступа к этой странице"
    else
      redirect_to new_user_session_path, alert: "Войдите, чтобы продолжить"
    end
  end

  private

  def teaser_gate
    return if current_user&.is_admin?
    return if controller_path.in?(%w[ home pages subscriptions ])
    return if devise_controller? && controller_name == "sessions"

    redirect_to root_path
  end
end
