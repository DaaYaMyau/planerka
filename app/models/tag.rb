class Tag < ApplicationRecord
  enum :kind, { profession: 0, topic: 1, stage: 2 }

  KIND_LABELS = { "profession" => "Профессия", "topic" => "Тема", "stage" => "Этап" }.freeze
  COLORS = %w[pink yellow green orange blue violet].freeze
  COLOR_LABELS = { "pink" => "Розовый", "yellow" => "Жёлтый", "green" => "Зелёный",
                   "orange" => "Оранжевый", "blue" => "Голубой", "violet" => "Фиолетовый" }.freeze

  has_many :story_tags, dependent: :destroy
  has_many :stories, through: :story_tags
  has_many :profiles, foreign_key: :profession_id, dependent: :nullify

  validates :name, presence: { message: "Укажите название тега" },
                   uniqueness: { scope: :kind, message: "Такой тег уже есть" }
  validates :color, inclusion: { in: COLORS, message: "Выберите цвет из списка" }, allow_blank: true
end
