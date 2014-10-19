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

require 'rails_helper'

describe User do
  pending 'Add tests'
end
