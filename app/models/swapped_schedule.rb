# ## Schema Information
#
# Table name: `swapped_schedules`
#
# ### Columns
#
# Name                    | Type               | Attributes
# ----------------------- | ------------------ | ---------------------------
# **`created_at`**        | `datetime`         |
# **`id`**                | `uuid`             | `not null, primary key`
# **`original_date`**     | `date`             | `not null`
# **`original_user_id`**  | `uuid`             | `not null`
# **`status`**            | `string(255)`      | `default("pending")`
# **`target_date`**       | `date`             | `not null`
# **`target_user_id`**    | `uuid`             | `not null`
# **`updated_at`**        | `datetime`         |
#

class SwappedSchedule < ActiveRecord::Base
  STATUSES = %w(pending accepted rejected)

  scope :accepted, -> { where(status: 'accepted') }

  belongs_to :original_user, class_name: 'User', inverse_of: :swapped_schedules
  belongs_to :target_user, class_name: 'User', inverse_of: :target_swapped_schedules

  validates :original_date, presence: true
  validates :target_date, presence: true
  validates :original_user, presence: true
  validates :target_user, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
end
