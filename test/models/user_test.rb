require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "при регистрации профиль создаётся сам, ник — начало email" do
    user = User.create!(email: "new.person@example.com", password: "testtest")

    assert_equal "new.person", user.profile.nickname
  end

  test "если ник занят, к нему добавляются цифры" do
    User.create!(email: "masha@gmail.com", password: "testtest")
    second = User.create!(email: "masha@mail.ru", password: "testtest")

    assert_match(/\Amasha\d{4}\z/, second.profile.nickname)
  end

  test "display_name — ник, а без профиля — начало email" do
    assert_equal "анна_джун", users(:anna).display_name

    profiles(:anna).destroy
    assert_equal "anna", users(:anna).reload.display_name
  end
end
