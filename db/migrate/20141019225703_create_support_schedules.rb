class CreateSupportSchedules < ActiveRecord::Migration
  def change
    create_table :support_schedules, id: :uuid do |t|
      t.uuid    :user_id, null: false
      t.date    :scheduled_at, null: false
      t.integer :position
      t.timestamps
    end

    add_index :support_schedules, [:scheduled_at, :user_id]
  end
end
