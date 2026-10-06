class CreateStories < ActiveRecord::Migration[8.1]
  def change
    create_table :stories do |t|
      t.references :user, null: false, foreign_key: true
      t.references :article, null: true, foreign_key: true
      t.string :title
      t.text :body
      t.integer :grade
      t.integer :status
      t.boolean :anonymous

      t.timestamps
    end
  end
end
