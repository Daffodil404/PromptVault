class User < ApplicationRecord
  has_many :prompts, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :prompt_versions, dependent: :destroy
  has_many :reviewed_prompts, -> { distinct }, through: :reviews, source: :prompt
  has_one :profile, dependent: :destroy

  has_secure_password

  validates :username, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  after_create_commit :create_default_profile!

  private

  def password_required?
    new_record? || password.present?
  end

  def create_default_profile!
    create_profile! unless profile
  end
end
