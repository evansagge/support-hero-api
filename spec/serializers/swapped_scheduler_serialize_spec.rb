require 'rails_helper'

describe SwappedScheduleSerializer do
  let(:swapped_schedule) { Fabricate(:swapped_schedule) }
  let(:serializer) { described_class.new(swapped_schedule) }
  let(:expected) do
    {
      id:               swapped_schedule.id,
      original_date:    swapped_schedule.original_date,
      target_date:      swapped_schedule.target_date,
      original_user_id: swapped_schedule.original_user.id,
      target_user_id:   swapped_schedule.target_user.id,
      status:           swapped_schedule.status,
      accepted:         swapped_schedule.status == 'accepted'
    }
  end

  it 'creates a JSON representation of a SwappedSchedule object' do
    expect(serializer.to_json).to be_json_eql(expected.to_json).at_path('swapped_schedule')
  end
end
