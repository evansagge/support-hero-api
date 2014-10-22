# ## Schema Information
#
# Table name: `support_order_users`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`id`**                | `uuid`             | `not null, primary key`
# **`position`**          | `integer`          | `not null`
# **`support_order_id`**  | `uuid`             | `not null`
# **`user_id`**           | `uuid`             | `not null`
#
# ### Indexes
#
# * `index_support_order_users_on_support_order_id_and_position`:
#     * **`support_order_id`**
#     * **`position`**
#

require 'rails_helper'

RSpec.describe SupportOrderUser, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
