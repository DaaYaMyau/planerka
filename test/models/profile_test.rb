require "test_helper"

class ProfileTest < ActiveSupport::TestCase
  setup do
    @profile = profiles(:boris)
  end

  test "ник обязателен" do
    @profile.nickname = ""
    assert_not @profile.valid?
  end

  test "ник уникален без учёта регистра, в том числе для кириллицы" do
    @profile.nickname = "  АННА_ДЖУН "

    assert_equal "анна_джун", @profile.nickname
    assert_not @profile.valid?
  end

  test "профессией может быть только тег-профессия" do
    @profile.profession = tags(:salary)
    assert_not @profile.valid?

    @profile.profession = tags(:design)
    assert @profile.valid?
  end

  test "аватар не может быть текстом с расширением .png" do
    @profile.avatar = file_fixture("not_image.png").open
    assert_not @profile.valid?
    assert_includes @profile.errors[:avatar], "Аватар должен быть картинкой: PNG, JPG или WEBP, не больше 5 МБ"
  end
end
