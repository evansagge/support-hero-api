class SupportScheduleList
  attr_reader :list_start_at

  delegate :support_order_users, :users, to: :support_order

  def initialize(list_start_at)
    @list_start_at = list_start_at.to_date

    SupportHolidays.detect(
      support_order.start_at,
      list_start_at.end_of_month
    ) if support_order.present?
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
  alias_method :at, :find_by_date

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
    date.saturday? || date.sunday? || SupportHolidays.include?(date)
  end
end
