class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :profession, class_name: "Tag", optional: true
  has_one_attached :avatar

  AVATAR_TYPES = %w[image/png image/jpeg image/webp image/gif].freeze

  attribute :remove_avatar, :boolean, default: false
  after_save :purge_avatar, if: :remove_avatar

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
    return unless avatar.attached?

    real_type = real_avatar_type
    looks_like_image = avatar.content_type.in?(AVATAR_TYPES)
    really_image = real_type.nil? || real_type.in?(AVATAR_TYPES)
    unless looks_like_image && really_image
      errors.add(:avatar, "Аватар должен быть картинкой: PNG, JPG, WEBP или GIF")
    end
    errors.add(:avatar, "Аватар должен быть не больше 2 МБ") if avatar.byte_size > 2.megabytes
  end

  def real_avatar_type
    file = attachment_changes["avatar"]&.attachable
    file = file[:io] if file.is_a?(Hash)
    return unless file.respond_to?(:read)

    Marcel::MimeType.for(file)
  end

  def purge_avatar
    avatar.purge_later
  end
end
