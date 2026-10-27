module Admin
  class StoriesController < BaseController
    def index
      @filtered = Story::FILTERS.any? { |filter| params[filter].present? }
      @stories = Story.filtered(params)
    end
  end
end
