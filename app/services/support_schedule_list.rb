class SupportScheduleList
  SCHEDULE_START_DATE = Date.parse('Oct 1, 2014')

  attr_reader :start_date

  delegate :support_order_users, :users, to: :support_order

  def initialize(start_date)
    @start_date = start_date
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

  def support_order
    @support_order ||= SupportOrder.where('start_at <= ?', start_date).order(start_at: :desc).first
  end

  protected

  def support_schedules_for(user)
    end_date = start_date.end_of_month

    (start_date..end_date).map do |date|
      next if date.saturday? || date.sunday? || date.holiday?(:us, :us_ca)

      support_schedule = find_by_date(date)
      support_schedule if user.nil? || user == support_schedule.user
    end.compact
  end

  def support_position(date)
    detect_holidays(date)
    support_order.start_at.business_days_until(date) % support_order_count + 1
  end

  def detect_holidays(end_date)
    Holidays.between(support_order.start_at, end_date, :us, :us_ca).map do |holiday|
      BusinessTime::Config.holidays << holiday[:date]
    end
  end

  def support_order_users
    @support_order_users ||= support_order.support_order_users.includes(:user)
  end

  def support_order_count
    @support_order_count ||= support_order_users.count
  end
end
