require "test_helper"

class BookTest < ActiveSupport::TestCase
  context "validations" do
    should validate_presence_of(:title)
    should validate_presence_of(:author)
  end
end
