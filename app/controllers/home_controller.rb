class HomeController < ApplicationController
  def index
    return render :splash if Rails.configuration.x.teaser && !current_user&.is_admin?

    @filtered = Story::FILTERS.any? { |filter| params[filter].present? }
    @stories = Story.filtered(params)
  end
end
