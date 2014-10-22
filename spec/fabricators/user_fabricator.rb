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

Fabricator :user do
  name { Faker::Name.name }
  password 'Pass1234'
  password_confirmation 'Pass1234'
end
