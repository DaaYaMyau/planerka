require "test_helper"

class ReviewTest < ActiveSupport::TestCase
  test "ответ на «Что хотели бы знать заранее?» обязателен" do
    review = Review.new(user: users(:boris), company: companies(:pixel))
    assert_not review.valid?

    review.wish_i_knew = "Что тестовое будет на неделю."
    assert review.valid?
  end

  test "один человек — один отзыв о компании" do
    review = Review.new(user: users(:anna), company: companies(:cloud), wish_i_knew: "Ещё раз")
    assert_not review.valid?
  end

  test "по умолчанию отзыв на модерации и не анонимный" do
    review = Review.new
    assert review.pending?
    assert_not review.anonymous?
  end
end
