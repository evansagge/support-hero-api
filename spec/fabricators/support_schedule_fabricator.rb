Fabricator :support_schedule do
  user
  position 1
  date do
    sequence :support_schedule_date do |n|
      date = Date.new(2014, 10, 1)
      date.advance(days: n)
      date
    end
  end
end
