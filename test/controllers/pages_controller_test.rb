require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "в подвале ссылки на «Правила» и «Политику конфиденциальности»" do
    get root_url

    assert_includes response.body, %(href="#{rules_path}")
    assert_includes response.body, %(href="#{privacy_path}")

    get rules_url
    assert_includes response.body, "<h1>Правила Планёрки</h1>"
    get privacy_url
    assert_includes response.body, "<h1>Политика конфиденциальности</h1>"
  end

  test "страница «О проекте» открывается, в оглавлении ссылки на все разделы" do
    get about_url
    assert_response :success

    %w[ about how rules anonymity contacts ].each do |anchor|
      assert_includes response.body, %(href="##{anchor}")
      assert_includes response.body, %(id="#{anchor}")
    end
  end
end
