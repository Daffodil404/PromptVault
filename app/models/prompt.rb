class Prompt < ApplicationRecord
  belongs_to :user
  has_many :prompt_versions, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :prompt_taggings, dependent: :destroy
  has_many :tags, -> { order(:name) }, through: :prompt_taggings
  has_many :reviewing_users, -> { distinct }, through: :reviews, source: :user

  validates :title, presence: true
  validates :abstract, presence: true
  validates :content, presence: true
  validates :status, presence: true

  def tag_names
    tags.pluck(:name).join(", ")
  end

  def sync_tags_from_names!(names_string)
    parsed_names = names_string.to_s.split(",").map { |name| name.strip.downcase }.reject(&:blank?).uniq
    self.tags = parsed_names.map { |name| Tag.find_or_create_by!(name: name) }
  end
end
