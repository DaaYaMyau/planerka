class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :stories, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :company_representatives, dependent: :destroy
  has_many :created_companies, class_name: "Company", foreign_key: :created_by_id, dependent: :nullify
  has_many :bookmarked_stories, through: :bookmarks, source: :story

  after_create :create_default_profile

  def display_name
    profile&.nickname || email_name
  end

  def email_name
    email.split("@").first
  end

  private

  def create_default_profile
    base = email_name.downcase.first(25)
    nickname = base
    nickname = "#{base}#{rand(1000..9999)}" while Profile.exists?(nickname: nickname)

    create_profile!(nickname: nickname)
  end
end
