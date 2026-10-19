require "test_helper"

class AdminRoleTest < ActionDispatch::IntegrationTest
  setup do
    sign_in users(:admin)
    @story = stories(:published)
    @company = companies(:cloud)
  end

  test "админ пишет истории и статьи" do
    assert_difference("Story.count") do
      post stories_url, params: { story: { title: "История от редакции", body: "Текст", status: "published" } }
    end
    assert Story.last.published?

    assert_difference("Article.count") do
      post articles_url, params: { article: { title: "Новая статья", slug: "novaya-statya", summary: "Кратко", body: "Текст" } }
    end
  end

  test "черновик админа — без сообщения про модератора" do
    post stories_url, params: { story: { title: "Черновик", body: "Текст", status: "draft" } }
    follow_redirect!

    assert_includes response.body, "История сохранена: черновик"
  end

  test "админ не голосует, не комментирует и не сохраняет" do
    assert_no_difference([ "Vote.count", "Comment.count", "Bookmark.count" ]) do
      post story_votes_url(@story), params: { verdict: "normal" }
      post story_comments_url(@story), params: { comment: { body: "Текст" } }
      post story_bookmark_url(@story)
    end
  end

  test "на странице истории у админа нет кнопок участника, но видны итоги голосования" do
    get story_url(@story)

    assert_not_includes response.body, "Написать комментарий"
    assert_not_includes response.body, ">Сохранить<"
    assert_not_includes response.body, ">Норм</button>"
    assert_includes response.body, "Не норм — 100%"
    assert_not_includes response.body, "Войдите, чтобы"
  end

  test "в профиле админа — сводка с переходом к подписчикам, без блока «Управление»" do
    get profile_url

    assert_includes response.body, "Историй всего: #{Story.count}"
    assert_includes response.body, "Подписчиков: #{Subscription.count}"
    assert_includes response.body, %(href="#{admin_subscriptions_path}")
    assert_not_includes response.body, "Управление"
  end

  test "в меню у админа нет «Рассказать»" do
    get root_url
    assert_not_includes response.body, ">Рассказать</a>"
  end

  test "админ не действует от имени компании" do
    assert_no_difference([ "Review.count", "CompanyRepresentative.count", "ReviewReply.count" ]) do
      post company_reviews_url(@company), params: { review: { wish_i_knew: "Текст" } }
      post company_company_representatives_url(@company), params: { company_representative: { position: "HR", work_email: "a@cloud.example" } }
      post company_review_reply_url(@company, reviews(:boris_anonymous)), params: { review_reply: { body: "Ответ" } }
    end

    patch company_review_reply_url(@company, reviews(:anna_published)), params: { review_reply: { body: "Взлом" } }
    assert_not_equal "Взлом", review_replies(:vera_on_anna).reload.body
  end

  test "на странице компании у админа нет кнопок «от имени компании» и формы отзыва" do
    get company_url(@company)

    assert_not_includes response.body, "Ответить от имени компании"
    assert_not_includes response.body, "Редактировать ответ"
    assert_not_includes response.body, "Я представляю эту компанию"
    assert_not_includes response.body, "Оставить отзыв"
    assert_includes response.body, "Удалить ответ"
  end

  test "в профиле админа нет «Сохранённого»" do
    get profile_url
    assert_not_includes response.body, "Сохранённое"
  end
end
