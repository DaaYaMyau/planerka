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

  test "на главной у гостя — сплэш без ленты, у админа — лента" do
    get root_url
    assert_includes response.body, "Узнать о запуске"
    assert_not_includes response.body, stories(:published).title

    sign_in users(:admin)
    get root_url
    assert_includes response.body, stories(:published).title
    assert_not_includes response.body, "Узнать о запуске"
  end

  test "в тизере фильтры ленты ведут в ленту админки" do
    sign_in users(:admin)

    get admin_stories_url
    assert_includes response.body, %(action="#{admin_stories_path}")
  end

  test "у гостя в шапке только главная и «о проекте», в подвале нет «Разделов»" do
    get about_url
    menu = response.body[/<nav class="O_HeaderNavigation">.*?<\/nav>/m]

    assert_includes menu, %(href="#{root_path}")
    assert_includes menu, %(href="#{about_path}")
    [ "разобраться", "отзывы", "рассказать историю", "Профиль", "Скоро" ].each do |text|
      assert_not_includes menu, text
    end
    assert_not_includes response.body, "Разделы:"
  end

  test "в мобильном меню гостя только «о проекте», у вошедшего остальные разделы — «Скоро»" do
    get about_url
    menu = response.body[/<nav class="O_MobileMenu".*?<\/nav>/m]

    assert_includes menu, %(href="#{about_path}")
    assert_not_includes menu, "разобраться"

    sign_in users(:boris)
    get about_url
    menu = response.body[/<nav class="O_MobileMenu".*?<\/nav>/m]

    assert_equal 4, menu.scan('title="Скоро"').size
  end

  test "у вошедшего пользователя в шапке остальные вкладки — «Скоро», в подвале есть «Разделы»" do
    sign_in users(:boris)
    get about_url
    menu = response.body[/<nav class="O_HeaderNavigation">.*?<\/nav>/m]

    assert_equal 4, menu.scan('title="Скоро"').size
    assert_includes response.body, "Разделы:"
  end

  test "на странице «О проекте» в шапке активна вкладка «о проекте»" do
    get about_url
    menu = response.body[/<nav class="O_HeaderNavigation">.*?<\/nav>/m]

    assert_includes menu, %(aria-current="page" href="#{about_path}")
    assert_includes menu, "tab_logo_light"
  end

  test "у админа одна шапка на всех страницах: сплэш, лента и разделы сайта" do
    sign_in users(:admin)

    [ root_url, admin_stories_url, companies_url ].each do |url|
      get url
      menu = response.body[/<nav class="O_HeaderNavigation">.*?<\/nav>/m]

      [ root_path, about_path, articles_path, companies_path, new_story_path, profile_path ].each do |path|
        assert_includes menu, %(href="#{path}"), url
      end
      assert_not_includes menu, "Скоро", url
    end
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
