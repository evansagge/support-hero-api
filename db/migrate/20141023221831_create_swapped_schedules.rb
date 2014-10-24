class CreateSwappedSchedules < ActiveRecord::Migration
  def change
    create_table :swapped_schedules, id: :uuid do |t|
      t.date :original_date, null: false
      t.date :target_date, null: false
      t.uuid :original_user_id, null: false
      t.uuid :target_user_id, null: false
      t.string :status, default: 'pending'
      t.timestamps
    end
  end
end
