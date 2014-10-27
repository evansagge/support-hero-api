class SupportSchedule
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :date, :user, :position, :swapped_schedule

  class << self
    def between(start_date, end_date, user = nil)
      support_schedules = []

      support_orders = SupportOrder.includes(support_order_users: :user)
        .where('start_at <= ?', end_date).order(start_at: :asc)

      support_orders.each_with_index do |support_order, n|
        next_support_order = support_orders[n + 1]
        start_date = [start_date, support_order.start_at].max
        support_end_date = next_support_order ? next_support_order.start_at - 1.day : end_date

        support_schedule_list = SupportScheduleList.new(support_order)
        support_schedules.concat(support_schedule_list.all(start_date, support_end_date))
      end

      return support_schedules if user.nil?

      support_schedules.select { |schedule| schedule.user == user }
    end

    def find(date)
      support_order = SupportOrder.for_date(date)

      return nil if support_order.nil?

      support_schedule_list = SupportScheduleList.new(support_order)
      support_schedule_list.find(date)
    end
  end
end
