require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "в подвале ссылки на разделы и политику конфиденциальности" do
    get root_url
    footer = response.body[/<footer class="O_Footer[^"]*">.*?<\/footer>/m]

    assert_includes footer, %(href="#{about_path}")
    assert_includes footer, %(href="#{privacy_path}")

    get rules_url
    assert_select "h1", "Правила Планёрки"
    get privacy_url
    assert_select "h1", "Политика конфиденциальности"
  end

  test "страница «О проекте» открывается и содержит все разделы" do
    get about_url
    assert_response :success

    %w[ goal how principles rules safety team ].each do |anchor|
      assert_includes response.body, %(id="#{anchor}")
    end
  end
end
