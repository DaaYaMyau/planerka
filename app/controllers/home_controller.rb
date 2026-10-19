class HomeController < ApplicationController
  def index
    return render :splash if Rails.configuration.x.teaser

    @filtered = Story::FILTERS.any? { |filter| params[filter].present? }
    @stories = Story.filtered(params)
  end
end
