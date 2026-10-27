class CreateSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :subscriptions do |t|
      t.string :email, null: false
      t.datetime :consented_at, null: false

      t.timestamps
    end
    add_index :subscriptions, :email, unique: true
  end
end
