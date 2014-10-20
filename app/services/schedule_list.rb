class ScheduleList
  SCHEDULE_START_DATE = Date.parse('Oct 1, 2014')

  attr_reader :start_date, :end_date, :initial_position, :user

  def initialize(start_date, user)
    @start_date = start_date
    @user = user
    @initial_position = Schedule.get_position(start_date)
  end

  def schedules
    @schedules ||= generate_schedules
  end

  protected

  def generate_schedules
    end_date = start_date.end_of_month

    position = initial_position

    (start_date..end_date).each_with_object([]) do |date, schedules|
      next if date.saturday? || date.sunday? || date.holiday?(:us, :us_ca)

      user_name = SCHEDULE_HERO_ORDER[position]
      hero = users.find { |u| u.name == user_name }

      schedule = Schedule.new(date: date, user: hero, position: position)
      schedules << schedule if user.nil? || user == hero

      position += 1
      position = 0 if position >= SCHEDULE_HERO_ORDER.count
    end
  end

  def users
    @users ||= User.where(name: SCHEDULE_HERO_ORDER.uniq)
  end
end
