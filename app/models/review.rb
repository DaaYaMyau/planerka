class Review < ApplicationRecord
  belongs_to :user
  belongs_to :company
  has_one :reply, class_name: "ReviewReply", dependent: :destroy

  enum :grade, { student: 0, intern: 1, junior: 2, middle: 3, senior: 4 }, validate: { allow_nil: true }
  enum :status, { draft: 0, pending: 1, published: 2 }, validate: true

  QUESTIONS = {
    wish_i_knew: "Что хотели бы знать заранее?",
    suits: "Кому подойдёт?",
    not_suits: "Кому может не подойти?"
  }.freeze

  validates :company_id, uniqueness: { scope: :user_id, message: "Вы уже оставили отзыв об этой компании" }
  validates :wish_i_knew, presence: { message: "Расскажите, что хотели бы знать заранее" }
  validates :wish_i_knew, :suits, :not_suits, length: { maximum: 2000, message: "Ответ не может быть длиннее 2000 символов" }
end
