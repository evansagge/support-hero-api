require 'rails_helper'

describe UndoableScheduleSerializer do
  let(:undoable_schedule) { Fabricate(:undoable_schedule) }
  let(:serializer) { described_class.new(undoable_schedule) }
  let(:expected) do
    {
      id:       undoable_schedule.id,
      date:     undoable_schedule.date,
      reason:   undoable_schedule.reason,
      approved: undoable_schedule.approved?,
      user_id:  undoable_schedule.user.id
    }
  end

  it 'creates a JSON representation of a UndoableSchedule' do
    expect(serializer.to_json).to be_json_eql(expected.to_json).at_path('undoable_schedule')
  end
end
