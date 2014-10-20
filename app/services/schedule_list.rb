class ScheduleList
  SCHEDULE_START_DATE = Date.parse('Oct 1, 2014')

  attr_reader :start_date, :end_date, :initial_position

  def initialize(start_date)
    @start_date = start_date
    @end_date = start_date.end_of_month

    Holidays.between(SCHEDULE_START_DATE, start_date, :us, :us_ca).map do |holiday|
      BusinessTime::Config.holidays << holiday[:date]
    end

    @initial_position = SCHEDULE_START_DATE.business_days_until(start_date) % SCHEDULE_HERO_ORDER.count
  end

  def schedules
    @schedules ||= generate_schedules.compact
  end

  protected

  def generate_schedules
    schedule_position = initial_position

    (start_date..end_date).each_with_object([]) do |date, schedules|
      next if date.saturday? || date.sunday? || date.holiday?(:us, :us_ca)

      schedules << generate_schedule(schedule_position, date)

      schedule_position += 1
      schedule_position = 0 if schedule_position >= SCHEDULE_HERO_ORDER.count
    end
  end

  def generate_schedule(position, date)
    user_name = SCHEDULE_HERO_ORDER[position]
    user = users.find { |u| u.name == user_name }
    Schedule.new(date: date, user: user, position: position)
  end

  def users
    @users ||= User.where(name: SCHEDULE_HERO_ORDER.uniq)
  end
end
