require "test_helper"

class VotesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @story = stories(:published)
  end

  test "гостя отправляют на вход" do
    assert_no_difference("Vote.count") do
      post story_votes_url(@story), params: { verdict: "normal" }
    end
    assert_redirected_to new_user_session_url
  end

  test "пользователь голосует" do
    sign_in users(:anna)

    assert_difference("Vote.count") do
      post story_votes_url(@story), params: { verdict: "normal" }
    end
    assert @story.votes.find_by(user: users(:anna)).normal?
  end

  test "повторный голос меняет старый, а не создаёт второй" do
    sign_in users(:boris)

    assert_no_difference("Vote.count") do
      post story_votes_url(@story), params: { verdict: "disputed" }
    end
    assert votes(:boris_on_published).reload.disputed?
  end

  test "нажатие на тот же вариант отменяет голос" do
    sign_in users(:boris)

    assert_difference("Vote.count", -1) do
      post story_votes_url(@story), params: { verdict: "abnormal" }
    end
  end

  test "выдуманный вариант не сохраняется" do
    sign_in users(:anna)

    assert_no_difference("Vote.count") do
      post story_votes_url(@story), params: { verdict: "foo" }
    end
  end

  test "за чужую историю на модерации голосовать нельзя" do
    sign_in users(:boris)

    assert_no_difference("Vote.count") do
      post story_votes_url(stories(:pending)), params: { verdict: "normal" }
    end
    assert_redirected_to root_url
  end

  test "проценты видны только после голосования" do
    sign_in users(:anna)
    get story_url(@story)
    assert_select ".A_VotePercentage", 0

    sign_in users(:boris)
    get story_url(@story)
    assert_select ".M_VoteCount", "1 голос"
    assert_select ".M_VotingOptionChosen", /не норм/
  end

  test "строка про грейд появляется, если голосовал человек того же грейда" do
    sign_in users(:anna)
    post story_votes_url(@story), params: { verdict: "normal" }

    get story_url(@story)
    assert_includes response.body, "Люди вашего грейда ответили так"
  end
end
