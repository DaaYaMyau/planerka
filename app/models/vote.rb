class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :story

  # Колонка называется verdict, а не value: enum с именем value
  # создал бы метод Vote.values, который в Rails уже занят.
  enum :verdict, { normal: 0, disputed: 1, abnormal: 2 }, validate: true

  LABELS = { "normal" => "Норм", "disputed" => "Спорно", "abnormal" => "Не норм" }

  validates :user_id, uniqueness: { scope: :story_id }
end
