class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    if current_user.is_admin?
      @pending_stories = Story.pending.order(:created_at)
    else
      @stories = current_user.stories.order(created_at: :desc)
    end
  end
end