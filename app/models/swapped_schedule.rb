# ## Schema Information
#
# Table name: `swapped_schedules`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`approved`**          | `boolean`          |
# **`created_at`**        | `datetime`         |
# **`id`**                | `uuid`             | `not null, primary key`
# **`original_date`**     | `date`             |
# **`original_user_id`**  | `uuid`             |
# **`target_date`**       | `date`             |
# **`target_user_id`**    | `uuid`             |
# **`updated_at`**        | `datetime`         |
#

class SwappedSchedule < ActiveRecord::Base
end
