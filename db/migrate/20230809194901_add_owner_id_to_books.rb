class AddOwnerIdToBooks < ActiveRecord::Migration[7.0]
  def change
    add_reference :books, :owner, foreign_key: { to_table: :users }
  end
end
