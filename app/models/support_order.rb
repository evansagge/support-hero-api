# ## Schema Information
#
# Table name: `support_orders`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`created_at`**  | `datetime`         |
# **`id`**          | `uuid`             | `not null, primary key`
# **`start_at`**    | `date`             | `not null`
# **`updated_at`**  | `datetime`         |
#
# ### Indexes
#
# * `index_support_orders_on_start_at`:
#     * **`start_at`**
#

class SupportOrder < ActiveRecord::Base
  has_many :support_order_users, -> { order(position: :asc) }
  has_many :users, through: :support_order_users
end
