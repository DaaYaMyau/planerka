class VotesController < ApplicationController
  before_action :authenticate_user!

  def create
    story = Story.find(params.expect(:story_id))
    authorize! :show, story
    authorize! :create, Vote

    vote = story.votes.find_or_initialize_by(user: current_user)

    if vote.persisted? && vote.verdict == params[:verdict]
      vote.destroy
      return redirect_back_or_to story, notice: "Голос отменён"
    end

    vote.verdict = params[:verdict]

    if vote.save
      redirect_back_or_to story, notice: "Ваш голос учтён"
    else
      redirect_back_or_to story, alert: "Не удалось проголосовать"
    end
  end
end
