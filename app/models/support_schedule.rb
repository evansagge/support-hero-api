class SupportSchedule
  include ActiveModel::Model
  include ActiveModel::Serialization

  attr_accessor :date, :user, :position
end
