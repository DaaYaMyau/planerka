class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.string :nickname, null: false
      t.text :bio
      t.integer :grade
      t.references :profession, foreign_key: { to_table: :tags }

      t.timestamps
    end
    add_index :profiles, :nickname, unique: true
  end
end
