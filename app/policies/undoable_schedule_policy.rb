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
    @support_schedule ||= SupportSchedule.find(date)
  end
end
