require "test_helper"

module Admin
  class SubscriptionsControllerTest < ActionDispatch::IntegrationTest
    test "таблица подписчиков с датами и счётчиком" do
      sign_in users(:admin)

      get admin_subscriptions_url

      assert_response :success
      assert_includes response.body, "Всего: 1"
      assert_includes response.body, subscriptions(:masha).email
      assert_includes response.body, subscriptions(:masha).consented_at.strftime("%d.%m.%Y %H:%M")
    end

    test "список подписчиков не виден обычному пользователю" do
      sign_in users(:boris)

      get admin_subscriptions_url
      assert_redirected_to root_url
    end
  end
end
