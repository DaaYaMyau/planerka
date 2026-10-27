require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "текст обязателен и не длиннее 2000 символов" do
    comment = Comment.new(user: users(:anna), story: stories(:published))

    comment.body = ""
    assert_not comment.valid?

    comment.body = "а" * 2001
    assert_not comment.valid?

    comment.body = "а" * 2000
    assert comment.valid?
  end
end
