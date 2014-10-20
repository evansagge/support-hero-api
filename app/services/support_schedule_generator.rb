class SupportScheduleGenerator
  attr_reader :start_date, :end_date

  def initialize(start_date, end_date = nil)
    @start_date = start_date
    @end_date = end_date || start_date.end_of_month
  end

  def run
    schedule_position = 0

    (start_date..end_date).each do |date|
      next if date.saturday? || date.sunday? || date.holiday?(:us, :us_ca)

      create_schedule(schedule_position, date)

      schedule_position += 1
      schedule_position = 0 if schedule_position >= SCHEDULE_HERO_ORDER.count
    end
  end

  def create_schedule(position, date)
    user_name = SCHEDULE_HERO_ORDER[position]
    user = User.find_by(name: user_name)

    SupportSchedule.create!(user: user, scheduled_at: date, position: position)
  end
end
