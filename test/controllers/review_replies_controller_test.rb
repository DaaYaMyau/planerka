require "test_helper"

class ReviewRepliesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @company = companies(:cloud)
    @answered = reviews(:anna_published)
    @anonymous = reviews(:boris_anonymous)
  end

  test "ответ показывается под отзывом с плашкой" do
    get company_url(@company)

    assert_includes response.body, "Официальный ответ компании"
    assert_includes response.body, review_replies(:vera_on_anna).body
  end

  test "представитель отвечает на отзыв" do
    sign_in users(:vera)

    get company_url(@company)
    assert_includes response.body, "Ответить от имени компании"

    assert_difference("ReviewReply.count") do
      post company_review_reply_url(@company, @anonymous), params: { review_reply: { body: "Спасибо, разберёмся" } }
    end
    assert_equal users(:vera), @anonymous.reload.reply.user
  end

  test "второй ответ на тот же отзыв не создаётся" do
    sign_in users(:vera)

    assert_no_difference("ReviewReply.count") do
      post company_review_reply_url(@company, @answered), params: { review_reply: { body: "Ещё раз" } }
    end
  end

  test "пустой ответ не сохраняется" do
    sign_in users(:vera)

    post company_review_reply_url(@company, @anonymous), params: { review_reply: { body: "" } }
    assert_response :unprocessable_content
    assert_includes response.body, "Напишите текст ответа"
  end

  test "обычный пользователь и представитель другой компании ответить не могут" do
    sign_in users(:anna)
    get company_url(@company)
    assert_not_includes response.body, "Ответить от имени компании"

    assert_no_difference("ReviewReply.count") do
      post company_review_reply_url(@company, @anonymous), params: { review_reply: { body: "Взлом" } }
    end
  end

  test "представитель редактирует свой ответ" do
    sign_in users(:vera)

    patch company_review_reply_url(@company, @answered), params: { review_reply: { body: "Исправленный ответ" } }
    assert_equal "Исправленный ответ", review_replies(:vera_on_anna).reload.body
  end

  test "представитель не может удалить ответ, админ — может" do
    sign_in users(:vera)
    assert_no_difference("ReviewReply.count") do
      delete company_review_reply_url(@company, @answered)
    end

    sign_in users(:admin)
    assert_difference("ReviewReply.count", -1) do
      delete company_review_reply_url(@company, @answered)
    end
  end

  test "если автор правит отзыв после ответа — пометка" do
    sign_in users(:anna)

    patch company_review_url(@company, @answered), params: { review: { wish_i_knew: "Дополнила отзыв" } }
    assert @answered.reload.edited_after_reply?

    @answered.published!
    get company_url(@company)
    assert_includes response.body, "изменён после ответа компании"
  end

  test "правка отзыва без ответа пометку не ставит" do
    sign_in users(:boris)

    patch company_review_url(@company, @anonymous), params: { review: { wish_i_knew: "Дополнил" } }
    assert_not @anonymous.reload.edited_after_reply?
  end

  test "представитель не видит автора анонимного отзыва" do
    sign_in users(:vera)

    get company_url(@company)
    assert_includes response.body, @anonymous.wish_i_knew
    assert_not_includes response.body, profiles(:boris).nickname

    get new_company_review_reply_url(@company, @anonymous)
    assert_not_includes response.body, profiles(:boris).nickname
    assert_not_includes response.body, users(:boris).email
  end
end
