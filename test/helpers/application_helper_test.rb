require "test_helper"

class ApplicationHelperTest < ActionView::TestCase
  test "слово после числа меняет форму" do
    assert_equal "1 заявка", count_with_word(1, "заявка", "заявки", "заявок")
    assert_equal "2 заявки", count_with_word(2, "заявка", "заявки", "заявок")
    assert_equal "5 заявок", count_with_word(5, "заявка", "заявки", "заявок")
    assert_equal "11 заявок", count_with_word(11, "заявка", "заявки", "заявок")
    assert_equal "21 заявка", count_with_word(21, "заявка", "заявки", "заявок")
    assert_equal "112 заявок", count_with_word(112, "заявка", "заявки", "заявок")
  end
end
