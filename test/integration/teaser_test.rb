require "test_helper"

class TeaserTest < ActionDispatch::IntegrationTest
  setup { Rails.configuration.x.teaser = true }
  teardown { Rails.configuration.x.teaser = false }

  test "гостю открыты только главная, «О проекте» и вход" do
    [ root_url, about_url, rules_url, privacy_url, new_user_session_url ].each do |url|
      get url
      assert_response :success, url
    end

    [ companies_url, articles_url, story_url(stories(:published)), profile_url ].each do |url|
      get url
      assert_redirected_to root_url, url
    end
  end

  test "на главной — сплэш без ленты, у админа тоже" do
    get root_url
    assert_includes response.body, "Узнать о запуске"
    assert_not_includes response.body, stories(:published).title

    sign_in users(:admin)
    get root_url
    assert_includes response.body, "Узнать о запуске"
  end

  test "в тизере фильтры ленты ведут в ленту админки" do
    sign_in users(:admin)

    get admin_stories_url
    assert_includes response.body, %(action="#{admin_stories_path}")
  end

  test "у гостя в шапке только «Планёрка» и «О проекте»" do
    get root_url
    menu = response.body[/<nav class="menuBar">.*?<\/nav>/m]

    assert_includes menu, ">Планёрка</a>"
    assert_includes menu, ">О проекте</a>"
    %w[ Войти Регистрация Разобраться Отзывы Рассказать Профиль ].each do |label|
      assert_not_includes menu, ">#{label}</a>"
    end
  end

  test "у админа одна шапка на всех страницах: сплэш, лента и разделы сайта" do
    sign_in users(:admin)

    [ root_url, admin_stories_url, companies_url ].each do |url|
      get url
      menu = response.body[/<nav class="menuBar">.*?<\/nav>/m]

      [ "Планёрка", "О проекте", "Лента", "Новая история", "Разобраться", "Отзывы", "Профиль" ].each do |label|
        assert_includes menu, ">#{label}</a>", url
      end
    end

    get root_url
    assert_includes response.body, "Узнать о запуске"
  end

  test "обычного пользователя тоже не пускают дальше главной" do
    sign_in users(:boris)

    get story_url(stories(:published))
    assert_redirected_to root_url

    post story_votes_url(stories(:published)), params: { verdict: "normal" }
    assert_redirected_to root_url
  end

  test "админу открыт весь сайт и админка" do
    sign_in users(:admin)

    [ companies_url, story_url(stories(:published)), profile_url, admin_stories_url, admin_subscriptions_url ].each do |url|
      get url
      assert_response :success, url
    end
  end

  test "в админку не пускают никого, кроме админа" do
    Rails.configuration.x.teaser = false
    sign_in users(:boris)

    get admin_stories_url
    assert_redirected_to root_url
  end

  test "после входа админа — на главную со сплэшем" do
    post user_session_url, params: { user: { email: users(:admin).email, password: "testtest" } }
    assert_redirected_to root_url
  end

  test "после входа обычного пользователя — на главную" do
    post user_session_url, params: { user: { email: users(:boris).email, password: "testtest" } }
    assert_redirected_to root_url
  end

  test "на странице входа нет ссылок на регистрацию и восстановление пароля" do
    get new_user_session_url

    assert_not_includes response.body, "Регистрация"
    assert_not_includes response.body, "Забыли пароль"
  end
end
