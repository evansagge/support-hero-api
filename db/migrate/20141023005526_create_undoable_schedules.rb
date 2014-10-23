class CreateUndoableSchedules < ActiveRecord::Migration
  def change
    create_table :undoable_schedules, id: :uuid do |t|
      t.date :date, null: false
      t.string :reason
      t.uuid :user_id, null: false
      t.boolean :approved, default: false
      t.timestamps
    end

    add_index :undoable_schedules, :date, unique: true
    add_index :undoable_schedules, :user_id
  end
end
