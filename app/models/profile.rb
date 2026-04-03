class Profile < ApplicationRecord
  belongs_to :user

  validates :user_id, uniqueness: true
  validates :bio, length: { maximum: 500 }
  validates :location, length: { maximum: 100 }
  validates :website, length: { maximum: 255 }
  validates :favorite_prompt_style, length: { maximum: 100 }
end
