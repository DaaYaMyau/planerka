require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "страница «О нас» открывается, в оглавлении ссылки на все разделы" do
    get about_url
    assert_response :success

    %w[ about how rules anonymity contacts ].each do |anchor|
      assert_includes response.body, %(href="##{anchor}")
      assert_includes response.body, %(id="#{anchor}")
    end
  end
end
