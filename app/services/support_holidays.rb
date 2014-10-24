class SupportHolidays
  attr_reader :start_date, :end_date

  class << self
    def include?(date)
      BusinessTime::Config.holidays.include?(date)
    end

    def detect(start_date, end_date)
      support_holidays = new(start_date, end_date)
      support_holidays.detect
    end
  end

  def initialize(start_date, end_date)
    @start_date = start_date
    @end_date = end_date
  end

  def detect
    undoable_days.each(&method(:apply_holiday))
    state_holidays.each(&method(:apply_holiday))
  end

  def apply_holiday(date)
    BusinessTime::Config.holidays.push(date)
  end

  def undoable_days
    @undoable_days ||= UndoableSchedule.approved.between_dates(start_date, end_date).pluck(:date)
  end

  def state_holidays
    @state_holidays ||= Holidays.between(start_date, end_date, :us, :us_ca).map { |h| h[:date] }
  end
end
