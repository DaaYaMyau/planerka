class HomeController < ApplicationController
  FILTERS = %i[ q profession topic stage grade ].freeze

  def index
    @filtered = FILTERS.any? { |filter| params[filter].present? }
    @stories = Story.published
                    .with_tag(params[:profession]).with_tag(params[:topic]).with_tag(params[:stage])
                    .with_grade(params[:grade])
                    .search(params[:q])
                    .includes(:comments, user: { profile: { avatar_attachment: :blob } }, votes: { user: :profile })
                    .order(created_at: :desc)
  end
end
