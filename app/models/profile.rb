class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :profession, class_name: "Tag", optional: true
  mount_uploader :avatar, AvatarUploader, validate_integrity: false, validate_processing: false

  AVATAR_TYPES = %w[image/png image/jpeg image/webp].freeze

  enum :grade, { student: 0, intern: 1, junior: 2, middle: 3, senior: 4 }, validate: { allow_nil: true }

  normalizes :nickname, with: ->(nickname) { nickname.strip.downcase }

  validates :nickname, presence: { message: "Укажите ник" },
                       uniqueness: { message: "Этот ник уже занят" },
                       length: { maximum: 30, message: "Ник не может быть длиннее 30 символов" }
  validate :profession_must_be_profession_tag
  validate :avatar_must_be_small_image

  private

  def profession_must_be_profession_tag
    return if profession.nil? || profession.profession?

    errors.add(:profession, "Выберите профессию из списка")
  end

  def avatar_must_be_small_image
    return if avatar_integrity_error.nil? && avatar_processing_error.nil?

    errors.add(:avatar, "Аватар должен быть картинкой: PNG, JPG или WEBP, не больше 5 МБ")
  end
end
