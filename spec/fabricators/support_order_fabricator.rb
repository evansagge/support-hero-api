# ## Schema Information
#
# Table name: `support_orders`
#
# ### Columns
#
# Name              | Type               | Attributes
# ----------------- | ------------------ | ---------------------------
# **`created_at`**  | `datetime`         |
# **`id`**          | `uuid`             | `not null, primary key`
# **`start_at`**    | `date`             | `not null`
# **`updated_at`**  | `datetime`         |
#
# ### Indexes
#
# * `index_support_orders_on_start_at`:
#     * **`start_at`**
#

Fabricator :support_order do
  transient :skip_users
  start_at { Date.new(2014, 10, 1) }
  after_create do |support_order, transients|
    unless transients[:skip_users]
      users = Fabricate.times(6, :user)
      user_position_list = [1, 0, 3, 4, 1, 5, 2, 1, 4, 0]
      user_position_list.each_with_index do |user_index, n|
        Fabricate(
          :support_order_user,
          support_order: support_order,
          user:          users[user_index],
          position:      n + 1
        )
      end
    end
  end
end

Fabricator :support_order_user do
  user
  support_order
end
