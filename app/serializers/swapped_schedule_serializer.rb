class SwappedScheduleSerializer < ApplicationSerializer
  attributes :id, :original_date, :target_date, :status, :accepted

  has_one :original_user, root: :users
  has_one :target_user, root: :users

  def accepted
    status == 'accepted'
  end
end
