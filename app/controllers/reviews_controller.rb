class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company
  before_action :set_review, only: %i[ edit update destroy ]

  def create
    authorize! :show, @company
    @review = @company.reviews.new(review_params)
    @review.user = current_user
    @review.status = current_user.is_admin? ? "published" : "pending"
    authorize! :create, @review

    if @review.save
      notice = @review.published? ? "Отзыв опубликован" : "Спасибо! Отзыв появится после проверки модератором"
      redirect_to @company, notice: notice
    else
      @reviews = @company.reviews.published.includes(user: :profile).order(created_at: :desc)
      @stories = @company.stories.published.order(created_at: :desc)
      render "companies/show", status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    @review.assign_attributes(review_params)
    @review.status = "pending" unless current_user.is_admin?
    @review.edited_after_reply = true if @review.reply.present? && @review.user == current_user

    if @review.save
      notice = "Отзыв отправлен на модерацию"
      notice = "Отзыв сохранён" if @review.published?
      notice = "Отзыв отклонён" if @review.rejected?
      redirect_to @company, notice: notice, status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @review.destroy!
    redirect_to @company, notice: "Отзыв удалён", status: :see_other
  end

  private

  def set_company
    @company = Company.find_by!(slug: params.expect(:company_id))
  end

  def set_review
    @review = @company.reviews.find(params.expect(:id))
    authorize! action_name.to_sym, @review
  end

  def review_params
    fields = [ :wish_i_knew, :suits, :not_suits, :grade, :anonymous ]
    fields << :status if current_user.is_admin?
    params.expect(review: fields)
  end
end
