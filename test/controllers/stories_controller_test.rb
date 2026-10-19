require "test_helper"

class StoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @published = stories(:published)
    @pending = stories(:pending)
  end

  test "гость видит опубликованную историю" do
    get story_url(@published)
    assert_response :success
  end

  test "на странице истории заголовок — h1, порядок «автор · грейд · дата», без висящего «|»" do
    get story_url(@published)

    assert_includes response.body, "<h1>#{@published.title}</h1>"
    assert_match(/#{profiles(:anna).nickname}\s*· Джун\s*· \d{2}\.\d{2}\.\d{4}/, response.body)
    assert_no_match(/<\/a>\s*\|/, response.body)
  end

  test "гость не видит историю на модерации" do
    get story_url(@pending)
    assert_redirected_to new_user_session_url
  end

  test "автор видит свою историю на модерации" do
    sign_in users(:anna)

    get story_url(@pending)
    assert_response :success
  end

  test "чужой пользователь не видит историю на модерации" do
    sign_in users(:boris)

    get story_url(@pending)
    assert_redirected_to root_url
  end

  test "гостя не пускают писать историю" do
    get new_story_url
    assert_redirected_to new_user_session_url
  end

  test "история обычного пользователя уходит на модерацию" do
    sign_in users(:boris)

    assert_difference("Story.count") do
      post stories_url, params: { story: { title: "Новая", body: "Текст", grade: "junior", status: "published" } }
    end

    story = Story.last
    assert_redirected_to story_url(story)
    assert story.pending?, "статус должен быть pending, даже если прислали published"
    assert_equal users(:boris), story.user
  end

  test "история с этапом, без грейда и с компанией" do
    sign_in users(:boris)

    post stories_url, params: { story: { title: "Новая", body: "Текст", grade: "",
                                         company_id: companies(:pixel).id, tag_ids: [ tags(:trial).id ] } }

    story = Story.last
    assert_nil story.grade
    assert_equal companies(:pixel), story.company
    assert_includes story.tags, tags(:trial)
  end

  test "в форме истории есть этапы, «Не указывать» и «Без компании»" do
    sign_in users(:boris)

    get new_story_url
    assert_includes response.body, "Этап"
    assert_includes response.body, tags(:trial).name
    assert_includes response.body, "Не указывать"
    assert_includes response.body, "Без компании"
  end

  test "на странице истории — ссылка на компанию" do
    get story_url(@published)
    assert_includes response.body, company_path(companies(:cloud))
  end

  test "пустую историю отправить нельзя" do
    sign_in users(:boris)

    assert_no_difference("Story.count") do
      post stories_url, params: { story: { title: "", body: "" } }
    end
    assert_response :unprocessable_content
    assert_includes response.body, "Напишите заголовок"
  end

  test "после правки автором история снова уходит на модерацию" do
    sign_in users(:anna)

    patch story_url(@published), params: { story: { title: "Исправленный заголовок" } }

    assert_redirected_to story_url(@published)
    assert @published.reload.pending?
  end

  test "чужой пользователь не может править историю" do
    sign_in users(:boris)

    patch story_url(@published), params: { story: { title: "Взлом" } }

    assert_redirected_to root_url
    assert_not_equal "Взлом", @published.reload.title
  end

  test "админ публикует историю" do
    sign_in users(:admin)

    patch story_url(@pending), params: { story: { status: "published" } }

    assert @pending.reload.published?
  end

  test "автор удаляет свою историю" do
    sign_in users(:anna)

    assert_difference("Story.count", -1) do
      delete story_url(@published)
    end
    assert_redirected_to profile_url

    follow_redirect!
    assert_response :success
    assert_includes response.body, "История удалена"
  end

  test "после удаления админа отправляют в ленту админки" do
    sign_in users(:admin)

    delete story_url(@published)
    assert_redirected_to admin_stories_url

    follow_redirect!
    assert_includes response.body, "История удалена"
  end

  test "чужой пользователь не может удалить историю" do
    sign_in users(:boris)

    assert_no_difference("Story.count") do
      delete story_url(@published)
    end
  end
end
