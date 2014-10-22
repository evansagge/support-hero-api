DEFAULT_PASSWORD = 'Pass1234'

# Create default manager
manager = User.where(name: 'Manager').first_or_initialize
manager.update!(password: DEFAULT_PASSWORD, password_confirmation: DEFAULT_PASSWORD) if manager.new_record?
manager.update!(roles: %w(manager))

# Seed users
%w(Sherry Boris Vicente Matte Jack Kevin Zoe Jay Eadon Franky Luis James).each do |name|
  user = User.where(name: name).first_or_initialize
  user.update!(password: DEFAULT_PASSWORD, password_confirmation: DEFAULT_PASSWORD) if user.new_record?
  user.update!(roles: %w(support))
end

# Seed initial default support order
schedule_start_date = Chronic.parse('Oct. 1, 2014').to_date
schedule_support_order = %w(
  Sherry Boris Vicente Matte Jack Sherry Matte Kevin Kevin Vicente Zoe Kevin Matte Zoe Jay Boris Eadon
  Sherry Franky Sherry Matte Franky Franky Kevin Boris Franky Vicente Luis Eadon Boris Kevin Matte Jay
  James Kevin Sherry Sherry Jack Sherry Jack
)
support_order = SupportOrder.where(start_at: schedule_start_date).first_or_create!
schedule_support_order.each_with_index do |user_name, index|
  user = User.find_by(name: user_name)

  support_order_user = support_order.support_order_users.where(position: index + 1).first_or_initialize
  support_order_user.update!(user: user)
end
