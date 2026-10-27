class ReviewReply < ApplicationRecord
  belongs_to :review
  belongs_to :user

  validates :review_id, uniqueness: { message: "На этот отзыв компания уже ответила" }
  validates :body, presence: { message: "Напишите текст ответа" },
                   length: { maximum: 2000, message: "Ответ не может быть длиннее 2000 символов" }
end
