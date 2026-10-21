class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :story, counter_cache: true

  enum :verdict, { normal: 0, disputed: 1, abnormal: 2 }, validate: true

  LABELS = { "normal" => "Норм", "disputed" => "Спорно", "abnormal" => "Не норм" }

  validates :user_id, uniqueness: { scope: :story_id }
end
