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

require 'rails_helper'

RSpec.describe SupportOrder, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
