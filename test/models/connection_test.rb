require "test_helper"

class ConnectionTest < ActiveSupport::TestCase
  context "validations" do
    should validate_presence_of(:recipient_id)
    should validate_presence_of(:sender_id)
    should validate_presence_of(:connection_status)
  end
end
