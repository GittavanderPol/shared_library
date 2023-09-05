class Connection < ApplicationRecord
  belongs_to :sender, class_name: "User"
  belongs_to :recipient, class_name: "User"

  validates :connection_status, presence: true, inclusion: {
    in: ["requested", "connected"],
    message: "%{value} is not a valid status"
  }
  validates :sender_id, presence: true, uniqueness: { scope: :recipient_id, message: ->(object, _data) { "You've already sent a request to #{object.recipient_email}" } }
  validates :recipient_id, presence: true
end
