class Tag < ApplicationRecord
  has_many :prompt_taggings, dependent: :destroy
  has_many :prompts, through: :prompt_taggings

  before_validation :normalize_name

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  private

  def normalize_name
    self.name = name.to_s.strip.downcase
  end
end
