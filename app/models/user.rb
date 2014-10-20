# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`created_at`**  | `datetime`         |
# **`id`**          | `uuid`             | `not null, primary key`
# **`name`**        | `string(255)`      |
# **`roles`**       | `string(255)`      | `is an Array`
# **`updated_at`**  | `datetime`         |
#

class User < ActiveRecord::Base
  has_many :support_schedules
end
