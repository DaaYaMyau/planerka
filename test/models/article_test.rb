require "test_helper"

class ArticleTest < ActiveSupport::TestCase
  test "заголовок статьи обязателен" do
    article = Article.new(slug: "novaya")
    assert_not article.valid?
    assert_includes article.errors[:title], "Напишите заголовок"
  end
end
