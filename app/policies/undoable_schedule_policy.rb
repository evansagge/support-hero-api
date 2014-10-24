class UndoableSchedulePolicy < ApplicationPolicy
  alias_method :undoable_schedule, :record

  delegate :date, to: :undoable_schedule

  def create?
    return true if manager?

    support_schedule.user == user if support_schedule.present?
  end

  def destroy?
    manager? || owner?
  end

  protected

  def support_schedule
    @support_schedule ||= support_schedule_list.at(date) if support_schedule_list
  end

  def support_schedule_list
    @support_schedule_list ||= SupportScheduleList.new(date) if date
  end
end
