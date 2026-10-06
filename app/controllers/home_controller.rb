class HomeController < ApplicationController
  def index
    @stories = Story.published.order(created_at: :desc)
  end
end