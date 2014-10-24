# ## Schema Information
#
# Table name: `users`
#
# ### Columns
#
# Name                   | Type               | Attributes
# ---------------------- | ------------------ | ---------------------------
# **`created_at`**       | `datetime`         |
# **`id`**               | `uuid`             | `not null, primary key`
# **`name`**             | `string(255)`      | `not null`
# **`password_digest`**  | `string(255)`      |
# **`roles`**            | `string(255)`      | `is an Array`
# **`updated_at`**       | `datetime`         |
#
# ### Indexes
#
# * `index_users_on_name`:
#     * **`name`**
#

class User < ActiveRecord::Base
  ROLES = %w(manager support)

  has_many :undoable_schedules
  has_many :swapped_schedules, foreign_key: :original_user_id
  has_many :target_swapped_schedules, foreign_key: :target_user_id

  has_secure_password

  def self.authenticate(name, password)
    user = find_by(name: name)
    user.present? && user.authenticate(password)
  end

  ROLES.each do |role|
    define_method "#{role}?" do
      Array(roles).include?(role)
    end
  end
end
