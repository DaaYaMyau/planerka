class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @stories = current_user.stories.order(created_at: :desc)
  end
end