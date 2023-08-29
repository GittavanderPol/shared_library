class Book < ApplicationRecord
  include PgSearch::Model

  belongs_to :owner, class_name: "User"

  validates :title, presence: true
  validates :author, presence: true

  pg_search_scope :search_by_title_and_author, against: [:title, :author], using: { tsearch: { prefix: true }}

  def self.from_user_and_connections(user)
    Book.where(owner_id: user.connection_user_ids)
  end

  def owner_is?(user)
    owner_id == user.id
  end
end
