class CompanyRepresentativesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_company, only: %i[ new create ]
  before_action :set_representative, only: %i[ show update ]

  def new
    @representative = @company.company_representatives.new
    authorize! :create, @representative
  end

  def create
    @representative = @company.company_representatives.new(representative_params)
    @representative.user = current_user
    authorize! :create, @representative

    if @representative.save
      redirect_to @company, notice: "Заявка отправлена. Модератор проверит её и сообщит решение в профиле"
    else
      render :new, status: :unprocessable_content
    end
  end

  def show
  end

  def update
    if params[:status] == "approved"
      @representative.approve!
      redirect_to profile_path, notice: "Заявка одобрена", status: :see_other
    else
      @representative.rejected!
      redirect_to profile_path, notice: "Заявка отклонена", status: :see_other
    end
  end

  private

  def set_company
    @company = Company.find_by!(slug: params.expect(:company_id))
    authorize! :show, @company
  end

  def set_representative
    @representative = CompanyRepresentative.find(params.expect(:id))
    authorize! :update, @representative
  end

  def representative_params
    params.expect(company_representative: [ :position, :work_email, :inn, :proof ])
  end
end
