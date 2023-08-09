class Book < ApplicationRecord
  include PgSearch::Model

  validates :title, presence: true
  validates :author, presence: true

  pg_search_scope :search_by_title_and_author, against: [:title, :author], using: { tsearch: { prefix: true }}
end
