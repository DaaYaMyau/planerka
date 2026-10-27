class Bookmark < ApplicationRecord
  belongs_to :user
  belongs_to :story

  validates :story_id, uniqueness: { scope: :user_id, message: "Эта история уже в сохранённом" }
end
