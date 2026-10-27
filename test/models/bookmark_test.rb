require "test_helper"

class BookmarkTest < ActiveSupport::TestCase
  test "одну историю нельзя сохранить дважды" do
    bookmark = Bookmark.new(user: users(:boris), story: stories(:published))
    assert_not bookmark.valid?
  end
end
