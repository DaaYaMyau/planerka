class AddDetailsToCompaniesAndReviews < ActiveRecord::Migration[8.1]
  def change
    add_column :companies, :website, :string
    add_column :companies, :description, :text
    add_column :companies, :inn, :string
    # 0 = pending (на модерации), 1 = published
    add_column :companies, :status, :integer, null: false, default: 0
    # Кто добавил компанию (у компаний, созданных раньше, — пусто)
    add_reference :companies, :created_by, foreign_key: { to_table: :users }
    # ИНН уникален. Пустых значений (NULL) может быть сколько угодно
    add_index :companies, :inn, unique: true

    add_column :reviews, :edited_after_reply, :boolean, null: false, default: false
  end
end
