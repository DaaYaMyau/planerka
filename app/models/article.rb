class Article < ApplicationRecord
  has_many :stories, dependent: :nullify

  scope :search, lambda { |query|
    next all if query.blank?

    text = query.strip.downcase
    ids = select(:id, :title, :summary, :body).select { |article| "#{article.title} #{article.summary} #{article.body}".downcase.include?(text) }.map(&:id)
    where(id: ids)
  }

  validates :title, presence: { message: "Напишите заголовок" }
  validates :slug, presence: { message: "Укажите адрес (slug)" }, uniqueness: { message: "Такой адрес уже занят" }

  def to_param
    slug
  end
end
