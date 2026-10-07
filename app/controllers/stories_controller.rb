class StoriesController < ApplicationController
  load_and_authorize_resource
  before_action :set_story, only: %i[ show edit update destroy ]

  # GET /stories or /stories.json
  def index
  end

  # GET /stories/1 or /stories/1.json
  def show
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
        format.html { redirect_to @story, notice: "Story was successfully created." }
        format.json { render :show, status: :created, location: @story }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @story.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /stories/1 or /stories/1.json
  def update
    respond_to do |format|
      if @story.update(story_params)
        format.html { redirect_to @story, notice: "Story was successfully updated.", status: :see_other }
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
      format.html { redirect_to stories_path, notice: "Story was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_story
      @story = Story.find(params.expect(:id))
    end

  # Only allow a list of trusted parameters through.
  def story_params
    if current_user.is_admin?
      params.expect(story: [ :article_id, :title, :body, :grade, :status, :anonymous, tag_ids: [] ])
    else
      params.expect(story: [ :title, :body, :grade, :anonymous, tag_ids: [] ])
    end
  end
end
