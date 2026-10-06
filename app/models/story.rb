class Story < ApplicationRecord
  belongs_to :user
  belongs_to :article, optional: true
  has_many :story_tags, dependent: :destroy
  has_many :tags, through: :story_tags
  enum :grade, { student: 0, intern: 1, junior: 2, middle: 3, senior: 4 }
  enum :status, { draft: 0, pending: 1, published: 2 }
end
