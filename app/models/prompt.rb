class Prompt < ApplicationRecord
  belongs_to :user
  has_many :prompt_versions, dependent: :destroy
  has_many :reviews, dependent: :destroy

  validates :title, presence: true
  validates :abstract, presence: true
  validates :content, presence: true
  validates :status, presence: true
end
