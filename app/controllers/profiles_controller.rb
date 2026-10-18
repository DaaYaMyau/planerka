class ProfilesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_profile, only: %i[ edit update ]

  def show
    if current_user.is_admin?
      @pending_stories = Story.pending.order(:created_at)
      @pending_reviews = Review.pending.includes(:company).order(:created_at)
      @pending_companies = Company.pending.includes(:created_by).order(:created_at)
      @pending_representatives = CompanyRepresentative.pending.includes(:company, user: :profile).order(:created_at)
    else
      @stories = current_user.stories.order(created_at: :desc)
      @reviews = current_user.reviews.includes(:company).order(created_at: :desc)
      @representatives = current_user.company_representatives.includes(:company).order(created_at: :desc)

      visible_stories = Story.accessible_by(current_ability, :show)
      @my_votes = current_user.votes.where(story: visible_stories).includes(:story).order(updated_at: :desc)
      @my_comments = current_user.comments.where(story: visible_stories).includes(:story).order(created_at: :desc)
      @bookmarked_stories = current_user.bookmarked_stories.where(id: visible_stories).order("bookmarks.created_at DESC")
    end
  end

  def edit
  end

  def update
    if @profile.update(profile_params)
      redirect_to profile_path, notice: "Профиль сохранён"
    else
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_profile
    @profile = current_user.profile || current_user.build_profile(nickname: current_user.email_name)
    authorize! :update, @profile
  end

  def profile_params
    params.expect(profile: [ :nickname, :bio, :grade, :profession_id, :avatar, :remove_avatar ])
  end
end
