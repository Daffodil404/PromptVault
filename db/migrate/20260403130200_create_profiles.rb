class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.text :bio
      t.string :location
      t.string :website
      t.string :favorite_prompt_style

      t.timestamps
    end
  end
end
