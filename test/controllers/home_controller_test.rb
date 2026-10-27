require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "главная показывает только опубликованные истории" do
    get root_url

    assert_response :success
    assert_includes response.body, stories(:published).title
    assert_not_includes response.body, stories(:pending).title
  end

  test "поиск и фильтры сочетаются и сохраняются в адресе" do
    get root_url, params: { q: "переработки", topic: tags(:salary).id, profession: tags(:design).id, grade: "junior" }

    assert_includes response.body, stories(:published).title
    assert_not_includes response.body, stories(:anonymous).title
    assert_includes response.body, %(value="переработки")
    assert_includes response.body, %(<option selected="selected" value="junior">)
    assert_includes response.body, "Сбросить"
  end

  test "фильтр по этапу" do
    get root_url, params: { stage: tags(:trial).id }

    assert_includes response.body, stories(:anonymous).title
    assert_not_includes response.body, stories(:published).title
  end

  test "если ничего не нашлось — понятная фраза и ссылка «Сбросить фильтры»" do
    get root_url, params: { q: "нет такого слова", grade: "senior" }

    assert_includes response.body, "По вашему запросу историй не нашлось"
    assert_includes response.body, "Сбросить фильтры"
  end

  test "без фильтров нет ссылки «Сбросить»" do
    get root_url
    assert_not_includes response.body, "Сбросить"
  end

  test "сортировка запоминается и сама по себе не считается фильтром" do
    get root_url, params: { sort: "popular" }

    assert_select "select[name=sort] option[selected][value=popular]"
    assert_not_includes response.body, "Сбросить"
  end

  test "автор анонимной истории скрыт" do
    get root_url

    assert_includes response.body, "Анонимно"
    assert_not_includes response.body, profiles(:boris).nickname
  end

  test "у автора виден ник, а не email" do
    get root_url

    assert_includes response.body, profiles(:anna).nickname
    assert_not_includes response.body, users(:anna).email
  end

  test "у истории без картинки в карточке нет блока картинки" do
    get root_url

    assert_select ".O_StoryCard", minimum: 1
    assert_select ".M_StoryCardMediaImage", 0
    assert_select ".Q_StoryImage", 0
  end

  test "под лентой синий подвал, на других страницах — обычный" do
    get root_url
    assert_select "footer.O_FooterBlue"
    assert_select "button.M_LoadMoreButton[hidden]"

    get about_url
    assert_select "footer.O_Footer"
    assert_select "footer.O_FooterBlue", 0
  end
end
