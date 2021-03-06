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

Fabricator :undoable_schedule do
  date { sequence(:undoable_schedule_date) { |n| n.days.from_now } }
  user
  reason 'Some reason'
end
