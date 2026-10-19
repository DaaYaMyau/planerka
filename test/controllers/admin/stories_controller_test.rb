require "test_helper"

module Admin
  class StoriesControllerTest < ActionDispatch::IntegrationTest
    test "лента в админке: опубликованные истории с фильтрами" do
      sign_in users(:admin)

      get admin_stories_url, params: { q: "переработки", grade: "junior" }

      assert_response :success
      assert_includes response.body, stories(:published).title
      assert_not_includes response.body, stories(:pending).title
      assert_not_includes response.body, stories(:anonymous).title
      assert_includes response.body, %(value="переработки")
    end

    test "в ленту админки не пускают обычного пользователя и гостя" do
      get admin_stories_url
      assert_redirected_to new_user_session_url

      sign_in users(:boris)
      get admin_stories_url
      assert_redirected_to root_url
    end
  end
end
