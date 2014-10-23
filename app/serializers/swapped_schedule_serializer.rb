class SwappedScheduleSerializer < ApplicationSerializer
  attributes :id, :original_date, :target_date

  has_one :original_user
  has_one :target_user
end
