class SupportScheduleList
  attr_reader :support_order

  delegate :user_list, :user_count, to: :support_order

  def initialize(support_order)
    @support_order = support_order
  end

  def all(start_date, end_date)
    detect_holidays(end_date)

    position = support_position(start_date)

    (start_date..end_date).each_with_object([]) do |date, support_schedules|
      next if skip_date?(date)

      user = user_list[position]
      swapped_schedule = swapped_schedules[date]
      support_schedule = SupportSchedule.new(
        date:             date,
        user:             swapped_schedule ? swapped_schedule.swapped_for(user) : user,
        position:         position,
        swapped_schedule: swapped_schedule
      )
      support_schedules << support_schedule

      position = (position % user_count) + 1
    end
  end

  def find(date)
    detect_holidays(date)

    return if skip_date?(date)

    position = support_position(date)
    swapped_schedule = swapped_schedules[date]
    user = user_list[position]

    SupportSchedule.new(
      date:             date,
      user:             swapped_schedule ? swapped_schedule.swapped_for(user) : user,
      position:         position,
      swapped_schedule: swapped_schedule
    )
  end
  alias_method :at, :find

  protected

  def support_position(date)
    support_order.start_at.business_days_until(date) % user_count + 1
  end

  def skip_date?(date)
    date.saturday? || date.sunday? || SupportHolidays.include?(date)
  end

  def detect_holidays(end_date)
    SupportHolidays.detect(support_order.start_at, end_date)
  end

  def swapped_schedules
    @swapped_schedules ||= SwappedSchedule.accepted.includes(:original_user, :target_user)
      .each_with_object({}) do |swapped_schedule, map|
      map[swapped_schedule.original_date] = swapped_schedule
      map[swapped_schedule.target_date] = swapped_schedule
    end
  end
end
