class UndoableScheduleSerializer < ApplicationSerializer
  attributes :id, :date, :reason, :approved

  has_one :user
end
