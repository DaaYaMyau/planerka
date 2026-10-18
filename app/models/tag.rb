class Tag < ApplicationRecord
  enum :kind, { profession: 0, topic: 1, stage: 2 }

  KIND_LABELS = { "profession" => "Профессия", "topic" => "Тема", "stage" => "Этап" }.freeze
  has_many :story_tags, dependent: :destroy
  has_many :stories, through: :story_tags
  has_many :profiles, foreign_key: :profession_id, dependent: :nullify

  validates :name, presence: { message: "Укажите название тега" },
                   uniqueness: { scope: :kind, message: "Такой тег уже есть" }

  def self.published_story_counts
    StoryTag.joins(:story).merge(Story.published).group(:tag_id).count
  end
end
