require "test_helper"

class SubscriptionTest < ActiveSupport::TestCase
  test "почта приводится к маленьким буквам, согласие записывается с датой" do
    subscription = Subscription.create!(email: "  New.Person@Example.RU ", consent: "1")

    assert_equal "new.person@example.ru", subscription.email
    assert_not_nil subscription.consented_at
  end

  test "без согласия не подписаться" do
    subscription = Subscription.new(email: "new@example.ru", consent: "0")

    assert_not subscription.valid?
    assert_includes subscription.errors[:consent], "Нужно согласие на обработку персональных данных"
  end

  test "почта проверяется и не повторяется, даже если написана большими буквами" do
    assert_not Subscription.new(email: "не почта", consent: "1").valid?
    assert_not Subscription.new(email: "MASHA@example.ru", consent: "1").valid?
  end
end
