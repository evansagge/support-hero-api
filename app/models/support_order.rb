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

  def self.for_date(date)
    where('start_at <= ?', date).order(start_at: :desc).first || first
  end

  def user_list
    @user_list ||= Hash[support_order_users.map { |item| [item.position, item.user] }]
  end

  def user_count
    @user_count ||= user_list.size
  end

  def support_schedules
    @support_schedules ||= SupportScheduleList.new(self)
  end
end
