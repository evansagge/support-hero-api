class SupportScheduleSwapper
  attr_reader :original_date, :target_date

  def self.policy_class
    SwappedSchedulePolicy
  end

  def initialize(original_date, target_date)
    @original_date = original_date
    @target_date = target_date
  end

  def save
    SwappedSchedule.create(
      original_date: original_date,
      original_user: original_user,
      target_date:   target_date,
      target_user:   target_user
    )
  end

  def original_user
    @original_user ||= original_support_schedule.user if original_support_schedule
  end

  def original_support_schedule
    @original_support_schedule ||= support_schedule_list.at(original_date) if original_date
  end

  def target_user
    @target_user ||= target_support_schedule.user if target_support_schedule
  end

  def target_support_schedule
    @target_support_schedule ||= support_schedule_list.at(target_date) if target_date
  end

  def support_schedule_list
    @support_schedule_list ||= SupportScheduleList.new(original_date) if original_date
  end
end
