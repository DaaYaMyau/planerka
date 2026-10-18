class CompaniesController < ApplicationController
  load_and_authorize_resource find_by: :slug, except: :similar

  def index
    companies = Company.published.order(:name)
    companies = companies.where(industry: params[:industry]) if params[:industry].present?
    @companies = Company.search(companies, params[:q])
    @published_counts = Review.published.group(:company_id).count
  end

  def similar
    @similar = Company.similar_to(params[:name])
    render layout: false
  end

  def show
    @reviews = published_reviews
    @stories = @company.stories.published.order(created_at: :desc)
    @review = Review.new
    @my_review = current_user&.reviews&.find_by(company: @company)
    @my_request = current_user&.company_representatives&.where(company: @company)&.order(:created_at)&.last
  end

  def new
    @company.name = params[:name]
  end

  def edit
  end

  def create
    @company.created_by = current_user
    @company.status = "pending" unless current_user.is_admin?

    if @company.save
      notice = @company.published? ? "Компания добавлена" : "Спасибо! Компания появится на сайте после проверки модератором. Отзыв можно оставить уже сейчас"
      redirect_to @company, notice: notice
    else
      render :new, status: :unprocessable_content
    end
  end

  def update
    if @company.update(company_params)
      redirect_to @company, notice: "Компания сохранена", status: :see_other
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @company.destroy!
    redirect_to companies_path, notice: "Компания удалена", status: :see_other
  end

  private

  def published_reviews
    @company.reviews.published.includes(:reply, user: { profile: { avatar_attachment: :blob } }).order(created_at: :desc)
  end

  def company_params
    if current_user.is_admin?
      params.expect(company: [ :name, :slug, :industry, :website, :description, :inn, :status ])
    elsif action_name == "update"
      params.expect(company: [ :industry, :website, :description, :inn ])
    else
      params.expect(company: [ :name, :industry, :website ])
    end
  end
end
