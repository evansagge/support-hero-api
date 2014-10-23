Fabricator :undoable_schedule do
  date { sequence(:undoable_schedule_date) { |n| n.days.from_now } }
  user
end
