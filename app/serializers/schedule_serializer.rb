class ScheduleSerializer < ActiveModel::Serializer
  attributes :date, :position

  has_one :user
end
