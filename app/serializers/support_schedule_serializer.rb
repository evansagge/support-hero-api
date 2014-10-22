class SupportScheduleSerializer < ApplicationSerializer
  attributes :id, :date, :position, :user_name

  has_one :user

  alias_method :id, :date

  delegate :name, to: :user, prefix: true
end
