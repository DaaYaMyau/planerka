class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :story

  validates :body, presence: { message: "Напишите текст комментария" },
                   length: { maximum: 2000, message: "Комментарий не может быть длиннее 2000 символов" }
end
