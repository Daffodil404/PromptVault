class User < ApplicationRecord
  has_many :prompts, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :prompt_versions, dependent: :destroy
  has_many :reviewed_prompts, -> { distinct }, through: :reviews, source: :prompt
  has_one :profile, dependent: :destroy

  devise :database_authenticatable, :registerable, :validatable

  validates :username, presence: true
  validates :role, presence: true
  validates :authentication_token, presence: true, uniqueness: true

  after_create_commit :create_default_profile!
  after_create_commit :send_welcome_email, on: :create
  before_validation :ensure_authentication_token, on: :create

  def regenerate_authentication_token!
    update!(authentication_token: self.class.generate_unique_authentication_token)
  end

  def self.generate_unique_authentication_token
    loop do
      token = Devise.friendly_token(32)
      break token unless exists?(authentication_token: token)
    end
  end

  private

  def ensure_authentication_token
    self.authentication_token ||= self.class.generate_unique_authentication_token
  end

  def create_default_profile!
    create_profile! unless profile
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_later
  end
end
