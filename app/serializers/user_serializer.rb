class UserSerializer < ApplicationSerializer
  attributes :id, :name, :links

  def links
    {
      support_schedules: v1_user_support_schedules_url(object)
    }
  end
end
