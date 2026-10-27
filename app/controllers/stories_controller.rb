class StoriesController < ApplicationController
  load_and_authorize_resource
  before_action :set_story, only: %i[ show edit update destroy ]

  # GET /stories or /stories.json
  def index
  end

  # GET /stories/1 or /stories/1.json
  def show
    @comments = @story.comments.includes(user: :profile).order(:created_at, :id)
    @comment = Comment.new
  end

  # GET /stories/new
  def new
    @story = Story.new
  end

  # GET /stories/1/edit
  def edit
  end

  # POST /stories or /stories.json
  def create
    @story = current_user.stories.new(story_params)
    @story.status = "pending" unless current_user.is_admin?

    respond_to do |format|
      if @story.save
        format.html { redirect_to @story, notice: story_saved_notice }
        format.json { render :show, status: :created, location: @story }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @story.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /stories/1 or /stories/1.json
  def update
    @story.assign_attributes(story_params)
    @story.status = "pending" unless current_user.is_admin?

    respond_to do |format|
      if @story.save
        format.html { redirect_to @story, notice: story_saved_notice, status: :see_other }
        format.json { render :show, status: :ok, location: @story }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @story.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /stories/1 or /stories/1.json
  def destroy
    @story.destroy!

    respond_to do |format|
      format.html { redirect_to current_user.is_admin? ? admin_stories_path : profile_path, notice: "История удалена", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params.expect(:id))
    end

  def story_saved_notice
    return "История опубликована" if @story.published?
    return "История отклонена" if @story.rejected?
    return "История сохранена: #{Story::STATUS_LABELS[@story.status].downcase}" if current_user.is_admin?

    "Спасибо! История появится после проверки модератором"
  end

  # Only allow a list of trusted parameters through.
  def story_params
    if current_user.is_admin?
      params.expect(story: [ :article_id, :company_id, :title, :body, :grade, :status, :anonymous,
                             tag_ids: [], images: [] ])
    else
      params.expect(story: [ :company_id, :title, :body, :grade, :anonymous,
                             tag_ids: [], images: [] ])
    end
  end
end
