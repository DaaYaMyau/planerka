require "test_helper"

class TagsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tag = tags(:salary)
  end

  test "гостя не пускают к управлению тегами" do
    get tags_url
    assert_redirected_to new_user_session_url
  end

  test "обычного пользователя не пускают к управлению тегами" do
    sign_in users(:anna)

    get tags_url
    assert_redirected_to root_url
  end

  test "админ видит теги" do
    sign_in users(:admin)

    get tags_url
    assert_response :success
  end

  test "на странице тега есть главный заголовок" do
    sign_in users(:admin)

    get tag_url(@tag)
    assert_includes response.body, "<h1>Тег «зарплата»</h1>"
  end

  test "админ создаёт тег" do
    sign_in users(:admin)

    assert_difference("Tag.count") do
      post tags_url, params: { tag: { name: "увольнение", kind: "topic" } }
    end
    assert_redirected_to tag_url(Tag.last)
  end

  test "админ редактирует тег" do
    sign_in users(:admin)

    patch tag_url(@tag), params: { tag: { name: "оплата труда" } }

    assert_redirected_to tag_url(@tag)
    assert_equal "оплата труда", @tag.reload.name
  end

  test "админ удаляет тег" do
    sign_in users(:admin)

    assert_difference("Tag.count", -1) do
      delete tag_url(@tag)
    end
    assert_redirected_to tags_url
  end
end
