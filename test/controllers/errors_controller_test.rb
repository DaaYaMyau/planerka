require "test_helper"

class ErrorsControllerTest < ActionDispatch::IntegrationTest
  test "страница 404 открывается со статусом «не найдено» и ссылкой на главную" do
    get "/404"

    assert_response :not_found
    assert_select "h1", "Эта страница уволилась"
    assert_select "a[href=?]", root_path, text: /На главную/
  end

  test "несуществующий адрес показывает страницу 404, как в продакшене" do
    Rails.application.env_config["action_dispatch.show_exceptions"] = :all
    Rails.application.env_config["action_dispatch.show_detailed_exceptions"] = false

    get "/net-takoi-stranitsy"

    assert_response :not_found
    assert_select "h1", "Эта страница уволилась"
  ensure
    Rails.application.env_config["action_dispatch.show_exceptions"] = :rescuable
    Rails.application.env_config["action_dispatch.show_detailed_exceptions"] = true
  end
end
