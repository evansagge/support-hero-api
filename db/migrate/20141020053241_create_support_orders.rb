class CreateSupportOrders < ActiveRecord::Migration
  def change
    create_table :support_orders, id: :uuid do |t|
      t.date :start_at, null: false
      t.timestamps
    end

    add_index :support_orders, :start_at
  end
end
