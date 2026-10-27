class ReviewRepliesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_review
  before_action :set_reply, only: %i[ edit update destroy ]

  def new
    @reply = ReviewReply.new(review: @review)
    authorize! :create, @reply
  end

  def create
    @reply = ReviewReply.new(review: @review, user: current_user, body: reply_params[:body])
    authorize! :create, @reply

    if @reply.save
      redirect_to company_path(@company, anchor: helpers.dom_id(@review)), notice: "Ответ опубликован"
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @reply.update(body: reply_params[:body])
      redirect_to company_path(@company, anchor: helpers.dom_id(@review)), notice: "Ответ сохранён", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @reply.destroy!
    redirect_to company_path(@company, anchor: helpers.dom_id(@review)), notice: "Ответ удалён", status: :see_other
  end

  private

  def set_review
    @company = Company.find_by!(slug: params.expect(:company_id))
    @review = @company.reviews.find(params.expect(:review_id))
  end

  def set_reply
    @reply = ReviewReply.find_by!(review: @review)
    authorize! action_name == "destroy" ? :destroy : :update, @reply
  end

  def reply_params
    params.expect(review_reply: [ :body ])
  end
end
