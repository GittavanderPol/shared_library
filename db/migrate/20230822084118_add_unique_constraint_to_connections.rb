class AddUniqueConstraintToConnections < ActiveRecord::Migration[7.0]
  def change
    add_index :connections, [:sender_id, :recipient_id], unique: true
  end
end
