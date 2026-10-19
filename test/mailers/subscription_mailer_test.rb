require "test_helper"

class SubscriptionMailerTest < ActionMailer::TestCase
  test "письмо-подтверждение подписки" do
    subscription = subscriptions(:masha)
    mail = SubscriptionMailer.with(subscription: subscription).welcome

    assert_equal "Вы подписались на Планёрку", mail.subject
    assert_equal [ subscription.email ], mail.to
    assert_match "сразу напишем", mail.text_part.body.decoded
    assert_match "http://example.com/about", mail.html_part.body.decoded
  end
end
