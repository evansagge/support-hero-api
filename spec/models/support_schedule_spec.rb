# ## Schema Information
#
# Table name: `support_schedules`
#
# ### Columns
#
# Name                | Type               | Attributes
# ------------------- | ------------------ | ---------------------------
# **`created_at`**    | `datetime`         |
# **`id`**            | `uuid`             | `not null, primary key`
# **`position`**      | `integer`          |
# **`scheduled_at`**  | `date`             | `not null`
# **`updated_at`**    | `datetime`         |
# **`user_id`**       | `uuid`             | `not null`
#
# ### Indexes
#
# * `index_support_schedules_on_scheduled_at_and_user_id`:
#     * **`scheduled_at`**
#     * **`user_id`**
#

require 'rails_helper'

RSpec.describe SupportSchedule, :type => :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
