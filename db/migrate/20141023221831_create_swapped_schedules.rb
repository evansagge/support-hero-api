class CreateSwappedSchedules < ActiveRecord::Migration
  def change
    create_table :swapped_schedules, id: :uuid do |t|
      t.date :original_date
      t.date :target_date
      t.uuid :original_user_id
      t.uuid :target_user_id
      t.boolean :approved
      t.timestamps
    end
  end
end
