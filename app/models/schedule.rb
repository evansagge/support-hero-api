class Schedule
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :date, :user, :position

  def self.find(date)
    detect_holidays(date)
    position = SCHEDULE_START_DATE.business_days_until(date)
    user_name = SCHEDULE_HERO_ORDER[position]
    user = User.find_by(name: user_name)
    new(user: user, date: date, position: position)
  end

  def self.detect_holidays(until_date)
    Holidays.between(SCHEDULE_START_DATE, until_date, :us, :us_ca).map do |holiday|
      BusinessTime::Config.holidays << holiday[:date]
    end
  end
end
