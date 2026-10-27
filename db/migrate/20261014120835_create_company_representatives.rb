class CreateCompanyRepresentatives < ActiveRecord::Migration[8.1]
  def change
    create_table :company_representatives do |t|
      t.references :user, null: false, foreign_key: true
      t.references :company, null: false, foreign_key: true
      t.string :position, null: false
      t.string :work_email, null: false
      t.string :inn
      t.text :proof
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
