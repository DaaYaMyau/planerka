require "test_helper"

class ArticlesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @article = articles(:overtime)
  end

  test "гость видит список статей" do
    get articles_url
    assert_response :success
  end

  test "поиск по статьям без учёта регистра" do
    get articles_url, params: { q: "ИСПЫТАТЕЛЬНЫЙ" }

    assert_includes response.body, articles(:trial).title
    assert_not_includes response.body, articles(:overtime).title
  end

  test "если статей не нашлось — фраза и ссылка «Сбросить поиск»" do
    get articles_url, params: { q: "нет такого" }

    assert_includes response.body, "не нашлось"
    assert_includes response.body, "Сбросить поиск"
  end

  test "популярные ситуации — темы по числу опубликованных историй, ссылка на главную с фильтром" do
    stories(:anonymous).tags << tags(:salary)
    Tag.create!(name: "отпуск", kind: "topic")

    get articles_url

    assert_includes response.body, "Популярные ситуации"
    assert_includes response.body, %(href="#{root_path(topic: tags(:salary).id)}">зарплата (2)</a>)
    assert_not_includes response.body, "отпуск (", "темы без опубликованных историй не показываем"
  end

  test "в меню «Разобраться» вместо «Юр. вопросы»" do
    get root_url

    assert_includes response.body, ">Разобраться</a>"
    assert_not_includes response.body, "Юр. вопросы"
  end

  test "статья открывается по slug" do
    get article_url(@article)

    assert_equal "/articles/pererabotki", article_path(@article)
    assert_response :success
  end

  test "гостя не пускают создавать статьи" do
    get new_article_url
    assert_redirected_to new_user_session_url
  end

  test "обычный пользователь не может создать статью" do
    sign_in users(:anna)

    assert_no_difference("Article.count") do
      post articles_url, params: { article: { title: "Новая", slug: "novaya", summary: "Кратко", body: "Текст" } }
    end
    assert_redirected_to root_url
  end

  test "админ создаёт статью" do
    sign_in users(:admin)

    assert_difference("Article.count") do
      post articles_url, params: { article: { title: "Новая", slug: "novaya", summary: "Кратко", body: "Текст" } }
    end
    assert_redirected_to article_url(Article.find_by(slug: "novaya"))
  end

  test "админ редактирует статью" do
    sign_in users(:admin)

    patch article_url(@article), params: { article: { title: "Переработки и закон" } }

    assert_redirected_to article_url(@article)
    assert_equal "Переработки и закон", @article.reload.title
  end

  test "админ удаляет статью" do
    sign_in users(:admin)

    assert_difference("Article.count", -1) do
      delete article_url(@article)
    end
    assert_redirected_to articles_url
  end
end
