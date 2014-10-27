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
      support_schedules << SupportSchedule.new(date: date, user: user_list[position], position: position)
      position = (position % user_count) + 1
    end
  end

  def find(date)
    detect_holidays(date)

    return if skip_date?(date)
    position = support_position(date)
    SupportSchedule.new(date: date, user: user_list[position], position: position)
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
end
