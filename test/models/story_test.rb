require "test_helper"

class StoryTest < ActiveSupport::TestCase
  test "vote_stats считает проценты" do
    story = stories(:published)
    story.votes.create!(user: users(:anna), verdict: "normal")

    assert_equal({ "normal" => 50, "disputed" => 0, "abnormal" => 50 }, story.reload.vote_stats)
  end

  test "без голосов везде ноль" do
    assert_equal({ "normal" => 0, "disputed" => 0, "abnormal" => 0 }, stories(:pending).vote_stats)
  end

  test "votes_from_grade — голоса других людей того же грейда" do
    story = stories(:published)

    assert_equal [ votes(:boris_on_published) ], story.votes_from_grade(users(:anna))
    assert_empty story.votes_from_grade(users(:boris)), "свой голос не считается"
  end
end

class StoryFiltersTest < ActiveSupport::TestCase
  test "поиск по заголовку и тексту без учёта регистра, в том числе по-русски" do
    assert_equal [ stories(:published) ], Story.published.search("ПЕРЕРАБОТКИ").to_a
    assert_equal [ stories(:anonymous) ], Story.published.search("наличными").to_a
    assert_empty Story.published.search("отпуск")
  end

  test "фильтр по тегу и грейду, фильтры сочетаются" do
    assert_equal [ stories(:published) ], Story.published.with_tag(tags(:salary).id).to_a
    assert_equal [ stories(:anonymous) ], Story.published.with_grade("intern").to_a
    assert_equal [ stories(:published) ], Story.published.with_tag(tags(:salary).id).with_tag(tags(:design).id).with_grade("junior").to_a
    assert_empty Story.published.with_tag(tags(:salary).id).with_grade("intern")
  end

  test "пустые и неверные значения фильтров ничего не ломают" do
    assert_equal Story.published.count, Story.published.with_tag("").with_grade("").search("").count
    assert_equal Story.published.count, Story.published.with_grade("boss").count
  end
end

class StoryValidationTest < ActiveSupport::TestCase
  test "заголовок и текст истории обязательны" do
    story = Story.new(user: users(:anna))
    assert_not story.valid?
    assert_includes story.errors[:title], "Напишите заголовок"
    assert_includes story.errors[:body], "Расскажите свою историю"
  end
end
