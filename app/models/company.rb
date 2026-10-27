class Company < ApplicationRecord
  belongs_to :created_by, class_name: "User", optional: true
  has_many :reviews, dependent: :destroy
  has_many :stories, dependent: :nullify
  has_many :company_representatives, dependent: :destroy

  enum :status, { pending: 0, published: 1, rejected: 2 }, validate: true
  STATUS_LABELS = { "pending" => "На модерации", "published" => "Опубликована", "rejected" => "Отклонена" }.freeze

  normalizes :slug, with: ->(slug) { slug.strip.downcase }
  normalizes :inn, with: ->(inn) { inn.strip.presence }
  normalizes :website, with: lambda { |website|
    website = website.strip
    if website.blank? then nil
    elsif website.start_with?("http://", "https://") then website
    else "https://#{website}"
    end
  }

  before_validation :set_slug, if: -> { slug.blank? && name.present? }

  validates :name, presence: { message: "Укажите название" }
  validates :slug, presence: { message: "Укажите адрес (slug)" },
                   uniqueness: { message: "Такой адрес уже занят" },
                   format: { with: /\A[a-z0-9-]+\z/, message: "Адрес — только латинские буквы, цифры и дефис" }
  validates :inn, uniqueness: { message: "Компания с таким ИНН уже есть" },
                  format: { with: /\A\d{10}(\d{2})?\z/, message: "ИНН — это 10 или 12 цифр" },
                  allow_nil: true

  def to_param
    slug
  end

  def verified?
    company_representatives.approved.exists?
  end

  def represented_by?(user)
    user.present? && company_representatives.approved.exists?(user: user)
  end

  def self.search(companies, query)
    return companies if query.blank?

    companies.select { |company| company.name.downcase.include?(query.strip.downcase) }
  end

  def self.similar_to(name)
    query = name.to_s.strip.downcase
    return [] if query.length < 3

    query_words = query.scan(/[[:alnum:]]{3,}/)
    published.order(:name).select do |company|
      company_name = company.name.downcase
      company_name.include?(query) || (company_name.scan(/[[:alnum:]]{3,}/) & query_words).any?
    end.first(5)
  end

  def self.industries
    published.where.not(industry: [ nil, "" ]).distinct.order(:industry).pluck(:industry)
  end

  private

  def set_slug
    base = name.parameterize.presence || "company"
    self.slug = base
    self.slug = "#{base}-#{rand(100..999)}" while Company.exists?(slug: slug)
  end
end
