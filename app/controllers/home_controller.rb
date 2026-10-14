class HomeController < ApplicationController
  def index
    @stories = Story.published.includes(:votes).order(created_at: :desc)
  end
end
