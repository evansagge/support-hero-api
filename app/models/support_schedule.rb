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

class SupportSchedule < ActiveRecord::Base
  default_scope { order(scheduled_at: :asc) }

  belongs_to :user

  validates :scheduled_at, presence: true, uniqueness: true
  validates :user, presence: true

  delegate :name, to: :user

  def self.by_month(year, month)
    start_date = Date.new(year, month)
    end_date = start_date.end_of_month
    where(scheduled_at: start_date..end_date)
  end
end
