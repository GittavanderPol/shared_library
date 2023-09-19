class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  has_many :books, foreign_key: :owner_id, dependent: :destroy

  has_many :connections,
    ->(user) { unscope(where: :user_id).where("sender_id = :user_id OR recipient_id = :user_id", user_id: user.id).where(connection_status: "connected") }, dependent: :destroy

  has_many :all_connections,
    ->(user) { unscope(where: :user_id).where("sender_id = :user_id OR recipient_id = :user_id", user_id: user.id) },
    class_name: "Connection", dependent: :destroy

  has_many :connections_sent,
    ->(user) { unscope(where: :user_id).where(sender_id: user.id, connection_status: "requested") },
    class_name: "Connection", dependent: :destroy

  has_many :connections_to_accept,
    ->(user) { unscope(where: :user_id).where(recipient_id: user.id, connection_status: "requested") },
    class_name: "Connection", dependent: :destroy

  def connected_users
    User.where(id: connection_user_ids - [id])
  end

  def connected_users_and_me
    User.where(id: connection_user_ids)
  end

  def connection_user_ids
    (connections.pluck(:sender_id, :recipient_id) + [id]).flatten.uniq
  end

  def self.with_book_count
    left_outer_joins(:books).select("users.*", "COUNT(books.id) AS book_count").group("users.id")
  end
end
