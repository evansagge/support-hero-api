# ## Schema Information
#
# Table name: `swapped_schedules`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`created_at`**        | `datetime`         |
# **`id`**                | `uuid`             | `not null, primary key`
# **`original_date`**     | `date`             | `not null`
# **`original_user_id`**  | `uuid`             | `not null`
# **`status`**            | `string(255)`      | `default("pending")`
# **`target_date`**       | `date`             | `not null`
# **`target_user_id`**    | `uuid`             | `not null`
# **`updated_at`**        | `datetime`         |
#

Fabricator :swapped_schedule do
  original_date 1.day.from_now
  target_date 2.days.from_now
  original_user { Fabricate(:user) }
  target_user { Fabricate(:user) }
end
