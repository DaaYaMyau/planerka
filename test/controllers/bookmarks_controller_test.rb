require "test_helper"

class BookmarksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @story = stories(:published)
  end

  test "гость не видит кнопку и не может сохранить" do
    get story_url(@story)
    assert_not_includes response.body, "Сохранить"

    post story_bookmark_url(@story)
    assert_redirected_to new_user_session_url
  end

  test "пользователь сохраняет историю" do
    sign_in users(:anna)

    assert_difference("Bookmark.count") do
      post story_bookmark_url(@story)
    end

    get story_url(@story)
    assert_includes response.body, "Убрать из сохранённого"
  end

  test "повторное сохранение не создаёт дубль" do
    sign_in users(:boris)

    assert_no_difference("Bookmark.count") do
      post story_bookmark_url(@story)
    end
  end

  test "пользователь убирает историю из сохранённого" do
    sign_in users(:boris)

    assert_difference("Bookmark.count", -1) do
      delete story_bookmark_url(@story)
    end
  end

  test "чужую историю на модерации сохранить нельзя" do
    sign_in users(:boris)

    assert_no_difference("Bookmark.count") do
      post story_bookmark_url(stories(:pending))
    end
  end

  test "снятая с публикации история пропадает из сохранённого" do
    stories(:published).update!(status: :pending)
    sign_in users(:boris)

    get profile_url
    assert_not_includes response.body, stories(:published).title
  end
end
