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

class SupportOrderUser < ActiveRecord::Base
  belongs_to :support_order
  belongs_to :user

  acts_as_list scope: :support_order

  validates :user, presence: true
  validates :position, presence: true
end
