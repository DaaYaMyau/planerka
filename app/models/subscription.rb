class Subscription < ApplicationRecord
  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :email, presence: { message: "Укажите почту" },
                    format: { with: URI::MailTo::EMAIL_REGEXP, message: "Проверьте почту — похоже, в ней опечатка" },
                    uniqueness: { message: "Эта почта уже подписана" }
  validates :consent, acceptance: { message: "Нужно согласие на обработку персональных данных" }

  before_validation :set_consented_at, on: :create

  private

  def set_consented_at
    self.consented_at = Time.current if consent == "1" || consent == true
  end
end
