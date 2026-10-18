class Story < ApplicationRecord
  belongs_to :user
  belongs_to :article, optional: true
  belongs_to :company, optional: true
  has_many :story_tags, dependent: :destroy
  has_many :tags, through: :story_tags
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  enum :grade, { student: 0, intern: 1, junior: 2, middle: 3, senior: 4 }
  enum :status, { draft: 0, pending: 1, published: 2 }

  validates :title, presence: { message: "Напишите заголовок" },
                    length: { maximum: 150, message: "Заголовок не может быть длиннее 150 символов" }
  validates :body, presence: { message: "Расскажите свою историю" }

  scope :with_tag, ->(tag_id) { where(id: StoryTag.where(tag_id: tag_id).select(:story_id)) if tag_id.present? }
  scope :with_grade, ->(grade) { where(grade: grade) if grades.key?(grade) }
  scope :search, lambda { |query|
    next all if query.blank?

    text = query.strip.downcase
    ids = select(:id, :title, :body).select { |story| "#{story.title} #{story.body}".downcase.include?(text) }.map(&:id)
    where(id: ids)
  }

  GRADE_LABELS = { "student" => "Студент", "intern" => "Стажёр", "junior" => "Джун", "middle" => "Мидл", "senior" => "Сеньор" }.freeze
  STATUS_LABELS = { "draft" => "Черновик", "pending" => "На модерации", "published" => "Опубликовано" }.freeze

  def vote_stats(selected_votes = votes)
    counts = selected_votes.map(&:verdict).tally
    total = selected_votes.size

    Vote.verdicts.keys.index_with do |verdict|
      total.zero? ? 0 : (counts.fetch(verdict, 0) * 100.0 / total).round
    end
  end

  def votes_from_grade(user)
    grade = user.profile&.grade
    return [] if grade.nil?

    votes.select { |vote| vote.user_id != user.id && vote.user.profile&.grade == grade }
  end
end
