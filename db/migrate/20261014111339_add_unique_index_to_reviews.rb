class AddUniqueIndexToReviews < ActiveRecord::Migration[8.1]
  def change
    # Один отзыв от одного человека об одной компании
    add_index :reviews, [ :user_id, :company_id ], unique: true
  end
end
