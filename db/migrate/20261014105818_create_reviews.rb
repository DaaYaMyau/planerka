class CreateReviews < ActiveRecord::Migration[8.1]
  def change
    create_table :reviews do |t|
      t.references :user, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.text :wish_i_knew, null: false
      t.text :suits
      t.text :not_suits
      t.integer :grade
      t.boolean :anonymous, null: false, default: false
      t.integer :status, null: false, default: 1 # 1 = pending, на модерации

      t.timestamps
    end
  end
end
