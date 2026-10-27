class CompanyRepresentative < ApplicationRecord
  belongs_to :user
  belongs_to :company

  enum :status, { pending: 0, approved: 1, rejected: 2 }, validate: true
  STATUS_LABELS = { "pending" => "На рассмотрении", "approved" => "Одобрена", "rejected" => "Отклонена" }.freeze

  normalizes :work_email, with: ->(email) { email.strip.downcase }
  normalizes :inn, with: ->(inn) { inn.strip.presence }

  validates :position, presence: { message: "Укажите должность" }
  validates :work_email, presence: { message: "Укажите рабочую почту" },
                         format: { with: URI::MailTo::EMAIL_REGEXP, message: "Проверьте рабочую почту" }
  validates :inn, format: { with: /\A\d{10}(\d{2})?\z/, message: "ИНН — это 10 или 12 цифр" }, allow_nil: true
  validate :no_open_request, on: :create

  def email_domain
    work_email.split("@").last
  end

  def website_domain
    return if company.website.blank?

    URI.parse(company.website).host&.delete_prefix("www.")
  rescue URI::InvalidURIError
    nil
  end

  def email_matches_website?
    return if website_domain.nil?

    email_domain == website_domain || email_domain.end_with?(".#{website_domain}")
  end

  def inn_matches_company?
    return if company.inn.blank? || inn.blank?

    inn == company.inn
  end

  def approve!
    transaction do
      approved!
      company.update!(inn: inn) if company.inn.blank? && inn.present? && !Company.exists?(inn: inn)
    end
  end

  private

  def no_open_request
    return unless CompanyRepresentative.where(user: user, company: company, status: %w[pending approved]).exists?

    errors.add(:base, "Вы уже подали заявку на эту компанию — дождитесь решения модератора")
  end
end
