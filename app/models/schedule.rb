class Schedule
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :date, :user, :position

  def self.find(date)
    position = get_position(date)
    user_name = SCHEDULE_HERO_ORDER[position]
    user = User.find_by(name: user_name)
    new(user: user, date: date, position: position)
  end

  def self.detect_holidays(until_date)
    Holidays.between(SCHEDULE_START_DATE, until_date, :us, :us_ca).map do |holiday|
      BusinessTime::Config.holidays << holiday[:date]
    end
  end

  def self.get_position(date)
    Schedule.detect_holidays(date)
    SCHEDULE_START_DATE.business_days_until(date) % SCHEDULE_HERO_ORDER.count
  end
end
