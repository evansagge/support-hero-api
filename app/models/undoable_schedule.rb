# ## Schema Information
#
# Table name: `undoable_schedules`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`approved`**    | `boolean`          | `default(FALSE)`
# **`created_at`**  | `datetime`         |
# **`date`**        | `date`             | `not null`
# **`id`**          | `uuid`             | `not null, primary key`
# **`reason`**      | `string(255)`      |
# **`updated_at`**  | `datetime`         |
# **`user_id`**     | `uuid`             | `not null`
#
# ### Indexes
#
# * `index_undoable_schedules_on_date` (_unique_):
#     * **`date`**
# * `index_undoable_schedules_on_user_id`:
#     * **`user_id`**
#

class UndoableSchedule < ActiveRecord::Base
  scope :approved, -> { where(approved: true) }
  scope :between_dates, ->(start_date, end_date) { where(date: start_date..end_date) }

  belongs_to :user

  validates :date, presence: true, uniqueness: true
  validates :user, presence: true
  validates :reason, presence: true
end
