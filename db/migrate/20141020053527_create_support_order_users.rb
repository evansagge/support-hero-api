class CreateSupportOrderUsers < ActiveRecord::Migration
  def change
    create_table :support_order_users, id: :uuid do |t|
      t.uuid    :support_order_id, null: false
      t.uuid    :user_id, null: false
      t.integer :position, null: false
    end

    add_index :support_order_users, [:support_order_id, :position]
  end
end
