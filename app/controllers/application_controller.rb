class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  rescue_from CanCan::AccessDenied do
    if user_signed_in?
      redirect_to root_path, alert: "У вас нет доступа к этой странице"
    else
      redirect_to new_user_session_path, alert: "Войдите, чтобы продолжить"
    end
  end
end
