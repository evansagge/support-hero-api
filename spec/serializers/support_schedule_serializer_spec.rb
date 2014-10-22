require 'rails_helper'

describe SupportScheduleSerializer do
  let(:support_schedule) { Fabricate(:support_schedule) }
  let(:serializer) { described_class.new(support_schedule) }

  let(:expected) do
    {
      id:        support_schedule.date,
      date:      support_schedule.date,
      position:  support_schedule.position,
      user_name: support_schedule.user.name,
      user_id:   support_schedule.user.id
    }
  end

  it 'creates a JSON representation of a SupportSchedule' do
    expect(serializer.to_json).to be_json_eql(expected.to_json).at_path('support_schedule')
  end
end
