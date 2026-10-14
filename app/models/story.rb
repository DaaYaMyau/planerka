class Story < ApplicationRecord
  belongs_to :user
  belongs_to :article, optional: true
  has_many :story_tags, dependent: :destroy
  has_many :tags, through: :story_tags
  has_many :votes, dependent: :destroy
  enum :grade, { student: 0, intern: 1, junior: 2, middle: 3, senior: 4 }
  enum :status, { draft: 0, pending: 1, published: 2 }

  def vote_stats
    counts = votes.map(&:verdict).tally
    total = votes.size

    Vote.verdicts.keys.index_with do |verdict|
      total.zero? ? 0 : (counts.fetch(verdict, 0) * 100.0 / total).round
    end
  end
end
