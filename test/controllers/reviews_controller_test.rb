require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company = companies(:cloud)
    @review = reviews(:anna_published)
  end

  test "гость не может оставить отзыв" do
    assert_no_difference("Review.count") do
      post company_reviews_url(@company), params: { review: { wish_i_knew: "Текст" } }
    end
    assert_redirected_to new_user_session_url
  end

  test "отзыв обычного пользователя уходит на модерацию" do
    sign_in users(:boris)
    pixel = companies(:pixel)

    assert_difference("Review.count") do
      post company_reviews_url(pixel), params: { review: { wish_i_knew: "Что офис далеко", status: "published" } }
    end

    review = Review.last
    assert review.pending?, "статус должен быть pending, даже если прислали published"
    assert_equal users(:boris), review.user
    assert_redirected_to company_url(pixel)
  end

  test "второй отзыв об одной компании оставить нельзя" do
    sign_in users(:anna)

    get company_url(@company)
    assert_includes response.body, "Вы уже оставили отзыв об этой компании"
    assert_includes response.body, edit_company_review_path(@company, @review)

    assert_no_difference("Review.count") do
      post company_reviews_url(@company), params: { review: { wish_i_knew: "Ещё один отзыв" } }
    end
    assert_includes response.body, "Вы уже оставили отзыв об этой компании"
  end


  test "без главного ответа отзыв не сохраняется" do
    sign_in users(:boris)

    assert_no_difference("Review.count") do
      post company_reviews_url(@company), params: { review: { wish_i_knew: "" } }
    end
    assert_response :unprocessable_content
    assert_includes response.body, "Расскажите, что хотели бы знать заранее"
  end

  test "после правки автором отзыв снова на модерации" do
    sign_in users(:anna)

    patch company_review_url(@company, @review), params: { review: { wish_i_knew: "Исправленный текст" } }

    assert @review.reload.pending?
    assert_equal "Исправленный текст", @review.wish_i_knew
  end

  test "чужой отзыв нельзя править и удалять" do
    sign_in users(:boris)

    get edit_company_review_url(@company, @review)
    assert_redirected_to root_url

    patch company_review_url(@company, @review), params: { review: { wish_i_knew: "Взлом" } }
    assert_not_equal "Взлом", @review.reload.wish_i_knew

    assert_no_difference("Review.count") do
      delete company_review_url(@company, @review)
    end
  end

  test "автор удаляет свой отзыв" do
    sign_in users(:anna)

    assert_difference("Review.count", -1) do
      delete company_review_url(@company, @review)
    end
  end

  test "админ публикует отзыв с модерации" do
    sign_in users(:admin)
    pending = reviews(:anna_pending)

    patch company_review_url(pending.company, pending), params: { review: { status: "published" } }
    assert pending.reload.published?
  end

  test "в профиле: у пользователя — мои отзывы, у админа — отзывы на модерации" do
    sign_in users(:anna)
    get profile_url
    assert_includes response.body, "Мои отзывы"
    assert_includes response.body, "На модерации"

    sign_in users(:admin)
    get profile_url
    assert_includes response.body, reviews(:anna_pending).wish_i_knew
    assert_includes response.body, companies_path
  end

  test "в меню есть пункт «Отзывы»" do
    get root_url
    assert_includes response.body, ">Отзывы</a>"
  end
end
