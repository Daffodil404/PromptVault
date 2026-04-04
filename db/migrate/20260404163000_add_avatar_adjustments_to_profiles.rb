class AddAvatarAdjustmentsToProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :profiles, :avatar_zoom, :decimal, precision: 3, scale: 2, null: false, default: 1.0
    add_column :profiles, :avatar_offset_x, :integer, null: false, default: 50
    add_column :profiles, :avatar_offset_y, :integer, null: false, default: 50
  end
end
