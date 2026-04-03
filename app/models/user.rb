class User < ApplicationRecord
  has_many :prompts, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :prompt_versions, dependent: :destroy

  has_secure_password

  validates :username, presence: true
  validates :email, presence: true, uniqueness: true
  validates :role, presence: true
  validates :password, presence: true, length: { minimum: 6 }, if: :password_required?

  private

  def password_required?
    new_record? || password.present?
  end
end
