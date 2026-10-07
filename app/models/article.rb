class Article < ApplicationRecord
  has_many :stories, dependent: :nullify

  validates :slug, presence: true, uniqueness: true

  def to_param
    slug
  end
end
