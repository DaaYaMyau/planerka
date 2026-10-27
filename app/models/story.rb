class Story < ApplicationRecord
  belongs_to :user
  belongs_to :article, optional: true
  belongs_to :company, optional: true
  has_many :story_tags, dependent: :destroy
  has_many :tags, through: :story_tags
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  mount_uploaders :images, StoryImageUploader, validate_integrity: false, validate_processing: false
  enum :grade, { student: 0, intern: 1, junior: 2, middle: 3, senior: 4 }
  enum :status, { draft: 0, pending: 1, published: 2, rejected: 3 }

  IMAGE_TYPES = %w[image/png image/jpeg image/webp].freeze
  MAX_IMAGES = 4

  validates :title, presence: { message: "Напишите заголовок" },
                    length: { maximum: 150, message: "Заголовок не может быть длиннее 150 символов" }
  validates :body, presence: { message: "Расскажите свою историю" }
  validate :images_must_be_small_pictures

  scope :with_tag, ->(tag_id) { where(id: StoryTag.where(tag_id: tag_id).select(:story_id)) if tag_id.present? }
  scope :with_grade, ->(grade) { where(grade: grade) if grades.key?(grade) }
  scope :search, lambda { |query|
    next all if query.blank?

    text = query.strip.downcase
    ids = select(:id, :title, :body).select { |story| "#{story.title} #{story.body}".downcase.include?(text) }.map(&:id)
    where(id: ids)
  }

  FILTERS = %i[ q profession topic stage grade ].freeze

  def self.filtered(filters)
    published.with_tag(filters[:profession]).with_tag(filters[:topic]).with_tag(filters[:stage])
             .with_grade(filters[:grade])
             .search(filters[:q])
             .includes(:comments, user: :profile, votes: { user: :profile })
             .sorted(filters[:sort])
  end

  SORT_LABELS = { "new" => "Сначала новые", "old" => "Сначала старые", "popular" => "Популярные" }.freeze

  def self.sorted(sort)
    case sort
    when "old" then order(created_at: :asc)
    when "popular" then order(votes_count: :desc, created_at: :desc)
    else order(created_at: :desc)
    end
  end

  GRADE_LABELS = { "student" => "Студент", "intern" => "Стажёр", "junior" => "Джун", "middle" => "Мидл", "senior" => "Сеньор" }.freeze
  STATUS_LABELS = { "draft" => "Черновик", "pending" => "На модерации", "published" => "Опубликовано", "rejected" => "Отклонено" }.freeze

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

  private

  def images_must_be_small_pictures
    errors.add(:images, "Можно прикрепить не больше #{MAX_IMAGES} картинок") if images.size > MAX_IMAGES

    if images_integrity_errors.any? || images_processing_errors.any?
      errors.add(:images, "Картинки должны быть в формате PNG, JPG или WEBP, каждая не больше 5 МБ")
    end
  end
end
