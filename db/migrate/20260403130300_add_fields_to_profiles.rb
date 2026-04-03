class AddFieldsToProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :profiles, :location, :string
    add_column :profiles, :website, :string
    add_column :profiles, :favorite_prompt_style, :string
  end
end
