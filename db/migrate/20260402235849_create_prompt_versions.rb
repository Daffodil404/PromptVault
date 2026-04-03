class CreatePromptVersions < ActiveRecord::Migration[8.1]
  def change
    create_table :prompt_versions do |t|
      t.integer :version_number
      t.text :content
      t.text :change_note
      t.references :prompt, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
