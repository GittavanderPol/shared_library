class CreateConnections < ActiveRecord::Migration[7.0]
  def change
    create_table :connections do |t|
      t.references :sender, foreign_key: { to_table: :users }
      t.references :recipient, foreign_key: { to_table: :users }
      t.string :connection_status, null: false, default: "requested"
      t.timestamps
    end
  end
end
