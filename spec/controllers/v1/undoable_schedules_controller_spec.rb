require 'rails_helper'

describe V1::UndoableSchedulesController do
  let(:user) { Fabricate(:user) }
  let(:token) { double(Doorkeeper::AccessToken, acceptable?: true, resource_owner_id: user.id) }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe 'GET :index' do
    let!(:undoable_schedules) { Fabricate.times(5, :undoable_schedule) }

    subject { get :index }

    it 'returns a list of undoable schedules' do
      expect(subject.body).to have_json_size(5).at_path('undoable_schedules')
      undoable_schedules.each do |undoable_schedule|
        expected = UndoableScheduleSerializer.new(undoable_schedule, root: false)
        expect(subject.body).to include_json(expected.to_json).at_path('undoable_schedules')
      end
    end
  end

  describe 'POST :create' do
    let(:undoable_schedule_attributes) { Fabricate.attributes_for(:undoable_schedule) }

    subject { post :create, undoable_schedule: undoable_schedule_attributes }

    it 'creates a new UndoableSchedule record' do
      expect { subject }.to change { UndoableSchedule.count }.by(1)
    end
  end

  describe 'GET :show' do
    let(:undoable_schedule) { Fabricate(:undoable_schedule) }

    subject { get :show, id: undoable_schedule.id }

    it 'returns a JSON representation of the undoable schedule' do
      expected = UndoableScheduleSerializer.new(undoable_schedule)
      expect(subject.body).to be_json_eql(expected.to_json)
    end
  end

  describe 'DELETE :destroy' do
    let!(:undoable_schedule) { Fabricate(:undoable_schedule) }

    subject { delete :destroy, id: undoable_schedule.id }

    it 'deletes the UndoableSchedule record' do
      expect { subject }.to change { UndoableSchedule.count }.by(-1)
      expect { UndoableSchedule.find(undoable_schedule.id) }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
