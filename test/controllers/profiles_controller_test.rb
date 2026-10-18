require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  test "на страницах входа, регистрации и смены пароля есть главный заголовок" do
    [ new_user_session_url, new_user_registration_url, new_user_password_url ].each do |url|
      get url
      assert_match(/<h1>.+<\/h1>/, response.body)
    end

    sign_in users(:boris)
    get edit_user_registration_url
    assert_includes response.body, "<h1>Почта и пароль</h1>"
  end

  test "гостя отправляют на вход" do
    get profile_url
    assert_redirected_to new_user_session_url

    get edit_profile_url
    assert_redirected_to new_user_session_url
  end

  test "пользователь видит свой профиль и сохранённое" do
    sign_in users(:boris)

    get profile_url

    assert_response :success
    assert_includes response.body, profiles(:boris).nickname
    assert_includes response.body, stories(:published).title
  end

  test "моя активность: голоса с вариантом и комментарии" do
    sign_in users(:boris)

    get profile_url
    assert_includes response.body, "Моя активность"
    assert_includes response.body, "Не норм"
    assert_includes response.body, comments(:boris_on_published).body
  end

  test "у админа в профиле нет «Моей активности»" do
    sign_in users(:admin)

    get profile_url
    assert_includes response.body, "На модерации"
    assert_not_includes response.body, "Моя активность"
  end

  test "пользователь меняет ник, грейд и профессию" do
    sign_in users(:boris)

    patch profile_url, params: { profile: { nickname: "борис_мидл", grade: "middle", profession_id: tags(:design).id } }

    assert_redirected_to profile_url
    profile = profiles(:boris).reload
    assert_equal "борис_мидл", profile.nickname
    assert profile.middle?
    assert_equal tags(:design), profile.profession
  end

  test "чужой ник занять нельзя" do
    sign_in users(:boris)

    patch profile_url, params: { profile: { nickname: profiles(:anna).nickname } }

    assert_response :unprocessable_content
    assert_includes response.body, "Этот ник уже занят"
  end

  test "подменить владельца профиля нельзя" do
    sign_in users(:boris)

    patch profile_url, params: { profile: { nickname: "новый_ник", user_id: users(:anna).id } }

    assert_equal users(:boris), profiles(:boris).reload.user
  end

  test "аватар загружается и удаляется" do
    sign_in users(:boris)

    patch profile_url, params: { profile: { avatar: fixture_file_upload("avatar.png", "image/png") } }
    assert profiles(:boris).reload.avatar.attached?

    patch profile_url, params: { profile: { remove_avatar: "1" } }
    perform_enqueued_jobs
    assert_not profiles(:boris).reload.avatar.attached?
  end

  test "вместо аватара нельзя загрузить текст" do
    sign_in users(:boris)

    patch profile_url, params: { profile: { avatar: fixture_file_upload("not_image.png", "image/png") } }

    assert_response :unprocessable_content
    assert_includes response.body, "Аватар должен быть картинкой"
  end
end
