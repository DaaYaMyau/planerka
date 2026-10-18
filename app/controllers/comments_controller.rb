class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_story

  def create
    authorize! :show, @story

    @comment = Comment.new(comment_params)
    @comment.story = @story
    @comment.user = current_user
    authorize! :create, @comment

    if @comment.save
      redirect_to story_path(@story, anchor: "comments"), notice: "Комментарий добавлен"
    else
      @comments = @story.comments.includes(user: { profile: { avatar_attachment: :blob } }).order(:created_at, :id)
      render "stories/show", status: :unprocessable_content
    end
  end

  def destroy
    comment = @story.comments.find(params.expect(:id))
    authorize! :destroy, comment

    comment.destroy
    redirect_to story_path(@story, anchor: "comments"), notice: "Комментарий удалён", status: :see_other
  end

  private

  def set_story
    @story = Story.find(params.expect(:story_id))
  end

  def comment_params
    params.expect(comment: [ :body ])
  end
end
