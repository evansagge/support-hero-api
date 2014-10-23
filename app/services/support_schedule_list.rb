class SupportScheduleList
  attr_reader :list_start_at

  delegate :support_order_users, :users, to: :support_order

  def initialize(list_start_at)
    @list_start_at = list_start_at

    detect_days_to_skip
  end

  def all(user = nil)
    return [] if support_order.nil?

    support_schedules_for(user)
  end

  def find_by_date(date)
    return nil if support_order.nil?

    position = support_position(date)
    support_order_user = support_order_users.find { |item| item.position == position }
    SupportSchedule.new(date: date, user: support_order_user.user, position: position)
  end

  protected

  def support_schedules_for(user)
    end_date = list_start_at.end_of_month

    (list_start_at..end_date).map do |date|
      next if skip_date?(date)

      support_schedule = find_by_date(date)
      support_schedule if user.nil? || user == support_schedule.user
    end.compact
  end

  def support_position(date)
    support_order.start_at.business_days_until(date) % support_order_count + 1
  end

  def support_order
    @support_order ||= SupportOrder.for_date(list_start_at)
  end

  def support_order_users
    @support_order_users ||= support_order.support_order_users.includes(:user)
  end

  def support_order_count
    @support_order_count ||= support_order_users.count
  end

  def skip_date?(date)
    date.saturday? || date.sunday? || holidays.include?(date)
  end

  def detect_days_to_skip
    return if support_order.nil?

    date_start = support_order.start_at
    date_end = list_start_at.end_of_month

    undoable_schedules = UndoableSchedule.approved.between_dates(date_start, date_end).pluck(:date)
    undoable_schedules.each(&method(:apply_holiday))

    holidays = Holidays.between(date_start, date_end, :us, :us_ca)
    holidays.each { |holiday| apply_holiday(holiday[:date]) }
  end

  def apply_holiday(date)
    holidays << date unless holidays.include?(date)
  end

  def holidays
    BusinessTime::Config.holidays
  end
end
