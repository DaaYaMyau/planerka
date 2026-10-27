class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_story

  def create
    authorize! :show, @story
    authorize! :create, Bookmark

    current_user.bookmarks.find_or_create_by!(story: @story)
    redirect_back_or_to @story, notice: "История сохранена"
  end

  def destroy
    current_user.bookmarks.where(story: @story).destroy_all
    redirect_back_or_to @story, notice: "История убрана из сохранённого", status: :see_other
  end

  private

  def set_story
    @story = Story.find(params.expect(:story_id))
  end
end
