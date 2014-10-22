Fabricator :support_order do
  start_at { Date.new(2014, 10, 1) }
  after_create do |support_order|
    10.times do |n|
      Fabricate(:support_order_user, support_order: support_order, position: n)
    end
  end
end

Fabricator :support_order_user do
  user
  support_order
end
