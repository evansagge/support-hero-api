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
# **`name`**        | `string(255)`      | `not null`
# **`roles`**       | `string(255)`      | `is an Array`
# **`updated_at`**  | `datetime`         |
#
# ### Indexes
#
# * `index_users_on_name`:
#     * **`name`**
#

require 'rails_helper'

describe User do
  pending 'Add tests'
end
