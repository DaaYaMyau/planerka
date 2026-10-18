require "test_helper"

class CommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @story = stories(:published)
    @comment = comments(:boris_on_published)
  end

  test "гость видит комментарии, но не может писать" do
    get story_url(@story)
    assert_includes response.body, @comment.body
    assert_includes response.body, "Войдите, чтобы прокомментировать"

    assert_no_difference("Comment.count") do
      post story_comments_url(@story), params: { comment: { body: "Привет" } }
    end
    assert_redirected_to new_user_session_url
  end

  test "пользователь пишет комментарий" do
    sign_in users(:anna)

    assert_difference("Comment.count") do
      post story_comments_url(@story), params: { comment: { body: "Спасибо за поддержку" } }
    end
    assert_redirected_to story_url(@story, anchor: "comments")
    assert_equal users(:anna), Comment.last.user
  end

  test "пустой комментарий не сохраняется" do
    sign_in users(:anna)

    assert_no_difference("Comment.count") do
      post story_comments_url(@story), params: { comment: { body: "" } }
    end
    assert_response :unprocessable_content
    assert_includes response.body, "Напишите текст комментария"
  end

  test "к чужой истории на модерации комментировать нельзя" do
    sign_in users(:boris)

    assert_no_difference("Comment.count") do
      post story_comments_url(stories(:pending)), params: { comment: { body: "Привет" } }
    end
  end

  test "автор удаляет свой комментарий" do
    sign_in users(:boris)

    assert_difference("Comment.count", -1) do
      delete story_comment_url(@story, @comment)
    end
  end

  test "чужой комментарий удалить нельзя" do
    sign_in users(:anna)

    assert_no_difference("Comment.count") do
      delete story_comment_url(@story, @comment)
    end
    assert_redirected_to root_url
  end

  test "админ удаляет любой комментарий" do
    sign_in users(:admin)

    assert_difference("Comment.count", -1) do
      delete story_comment_url(@story, @comment)
    end
  end
end
