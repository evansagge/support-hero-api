class SwappedSchedulePolicy < ApplicationPolicy
  alias_method :swapped_schedule, :record

  def create?
    swapped_schedule.original_user == user
  end

  def update?
    swapped_schedule.target_user == user
  end

  def destroy?
    create?
  end
end
