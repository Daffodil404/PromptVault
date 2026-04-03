class CreatePromptTaggings < ActiveRecord::Migration[8.1]
  def change
    create_table :prompt_taggings do |t|
      t.references :prompt, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end

    add_index :prompt_taggings, [:prompt_id, :tag_id], unique: true
  end
end
