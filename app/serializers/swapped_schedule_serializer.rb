class SwappedScheduleSerializer < ApplicationSerializer
  attributes :id, :original_date, :target_date, :status, :accepted

  has_one :original_user
  has_one :target_user

  def accepted
    status == 'accepted'
  end
end
