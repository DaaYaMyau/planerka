require "test_helper"

class TagTest < ActiveSupport::TestCase
  test "название тега обязательно и не повторяется внутри типа" do
    assert_not Tag.new(name: "", kind: "topic").valid?
    assert_not Tag.new(name: "зарплата", kind: "topic").valid?
    assert Tag.new(name: "зарплата", kind: "stage").valid?
  end
end
