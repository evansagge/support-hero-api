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
  STATUSES = %w(pending accepted rejected invalidated)

  scope :accepted, -> { where(status: 'accepted') }

  belongs_to :original_user, class_name: 'User', inverse_of: :swapped_schedules
  belongs_to :target_user, class_name: 'User', inverse_of: :target_swapped_schedules

  validates :original_date, presence: true
  validates :target_date, presence: true
  validates :original_user, presence: true
  validates :target_user, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }

  before_validation :calculate_original_user, on: :create
  before_validation :calculate_target_user, on: :create

  def self.between(start_date, end_date)
    where(
      arel_table[:original_date].in(start_date...end_date)
      .or(arel_table[:target_date].in(start_date...end_date))
    ).order(created_at: :asc)
  end

  def swapped_for(user)
    user == original_user ? target_user : original_user
  end

  protected

  def calculate_original_user
    self.original_user ||= begin
      original_support_schedule = SupportSchedule.find(original_date)
      original_support_schedule.try(:user)
    end
  end

  def calculate_target_user
    self.target_user ||= begin
      target_support_schedule = SupportSchedule.find(target_date)
      target_support_schedule.try(:user)
    end
  end
end
