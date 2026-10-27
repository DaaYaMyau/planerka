require "test_helper"

class VoteTest < ActiveSupport::TestCase
  test "один голос на пару пользователь + история" do
    vote = Vote.new(user: users(:boris), story: stories(:published), verdict: "normal")
    assert_not vote.valid?
  end

  test "только три варианта ответа" do
    vote = Vote.new(user: users(:anna), story: stories(:published), verdict: "foo")
    assert_not vote.valid?
  end
end
