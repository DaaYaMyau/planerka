require "test_helper"

class SubscriptionsControllerTest < ActionDispatch::IntegrationTest
  setup { Rails.configuration.x.teaser = true }
  teardown { Rails.configuration.x.teaser = false }

  test "на сплэше есть форма подписки" do
    get root_url

    assert_includes response.body, %(id="subscription_form")
    assert_includes response.body, "Согласен(на) на обработку персональных данных"
  end

  test "после подписки отправляется письмо-подтверждение" do
    assert_enqueued_emails 1 do
      post subscriptions_url, params: { subscription: { email: "new@example.ru", consent: "1" } }, as: :turbo_stream
    end
  end

  test "при ошибке письмо не отправляется" do
    assert_no_enqueued_emails do
      post subscriptions_url, params: { subscription: { email: "new@example.ru", consent: "0" } }, as: :turbo_stream
    end
  end

  test "успешная подписка заменяет форму без перезагрузки" do
    assert_difference("Subscription.count") do
      post subscriptions_url, params: { subscription: { email: "new@example.ru", consent: "1" } }, as: :turbo_stream
    end

    assert_response :success
    assert_equal "text/vnd.turbo-stream.html", response.media_type
    assert_includes response.body, %(<turbo-stream action="replace" target="subscription_form">)
    assert_includes response.body, "Вы подписаны, сообщим о запуске"
  end

  test "ошибка показывается в форме без перезагрузки" do
    assert_no_difference("Subscription.count") do
      post subscriptions_url, params: { subscription: { email: subscriptions(:masha).email, consent: "1" } }, as: :turbo_stream
    end

    assert_response :unprocessable_content
    assert_includes response.body, "Эта почта уже подписана"
    assert_includes response.body, %(target="subscription_form")
  end
end
