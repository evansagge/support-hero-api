class ScheduleSerializer < ActiveModel::Serializer
  attributes :id, :date, :position

  has_one :user

  alias_method :id, :date
end
