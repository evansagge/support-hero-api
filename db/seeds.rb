# Create default manager
manager = User.find_or_create_by!(name: 'Manager')
manager.update!(roles: %w(manager))

# Seed users
%w(Sherry Boris Vicente Matte Jack Kevin Zoe Jay Eadon Franky Luis James).each do |name|
  user = User.find_or_create_by!(name: name)
  user.update!(roles: %w(support))
end
