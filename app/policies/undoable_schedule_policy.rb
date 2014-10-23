class UndoableSchedulePolicy < ApplicationPolicy
  alias_method :undoable_schedule, :record

  def create?
    return true if manager?

    support_schedule.present? && support_schedule.user == user
  end

  def update?
    manager? || owner?
  end

  def destroy?
    manager? || owner?
  end

  protected

  def support_schedule
    @support_schedule ||= support_schedule_list.find_by_date(date) if support_schedule_list
  end

  def support_schedule_list
    @support_schedule_list ||= SupportScheduleList.new(date) if date
  end

  def date
    @date ||= undoable_schedule.date
  end
end
