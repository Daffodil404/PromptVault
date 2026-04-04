class Profile < ApplicationRecord
  AVATAR_MIN_ZOOM = 1.0
  AVATAR_MAX_ZOOM = 2.5

  belongs_to :user
  has_one_attached :avatar

  validates :user_id, uniqueness: true
  validates :bio, length: { maximum: 500 }
  validates :location, length: { maximum: 100 }
  validates :website, length: { maximum: 255 }
  validates :favorite_prompt_style, length: { maximum: 100 }
  validates :avatar_zoom, numericality: { greater_than_or_equal_to: AVATAR_MIN_ZOOM, less_than_or_equal_to: AVATAR_MAX_ZOOM }
  validates :avatar_offset_x, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :avatar_offset_y, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validate :acceptable_avatar

  def avatar_zoom_value
    avatar_zoom.presence || AVATAR_MIN_ZOOM
  end

  def avatar_offset_x_value
    avatar_offset_x.presence || 50
  end

  def avatar_offset_y_value
    avatar_offset_y.presence || 50
  end

  def avatar_presentation_style
    [
      "object-position: #{avatar_offset_x_value}% #{avatar_offset_y_value}%",
      "transform: scale(#{avatar_zoom_value})"
    ].join("; ")
  end

  private

  def acceptable_avatar
    return unless avatar.attached?

    unless avatar.blob.content_type.in?(%w[image/png image/jpeg image/jpg image/webp image/gif])
      errors.add(:avatar, "must be a PNG, JPG, JPEG, WEBP, or GIF")
    end

    return unless avatar.blob.byte_size > 5.megabytes

    errors.add(:avatar, "must be smaller than 5 MB")
  end
end
