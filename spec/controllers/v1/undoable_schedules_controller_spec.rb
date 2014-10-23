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
    let(:date) { Date.new(2014, 11, 5) }
    let(:undoable_schedule_attributes) { { date: date } }

    subject { post :create, undoable_schedule: undoable_schedule_attributes }

    context 'if current user is scheduled for support on the provided date' do
      let(:support_order) { Fabricate(:support_order, start_at: Date.new(2014, 11, 1)) }

      before do
        support_order_user = support_order.support_order_users.find_by(position: 3)
        support_order_user.update!(user: user)
      end

      it 'creates a new UndoableSchedule record' do
        expect { subject }.to change { UndoableSchedule.count }.by(1)
      end
    end

    context 'if current user is not scheduled for support on the provided date' do
      it 'does not create any UndoableSchedule record' do
        expect { subject }.not_to change { UndoableSchedule.count }
      end

      it 'returns a 403 Forbidden status' do
        expect(subject.status).to eq(403)
      end
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
    subject { delete :destroy, id: undoable_schedule.id }

    context 'if current user owns the undoable schedule' do
      let!(:undoable_schedule) { Fabricate(:undoable_schedule, user: user) }

      it 'deletes the UndoableSchedule record' do
        expect { subject }.to change { UndoableSchedule.count }.by(-1)
        expect { UndoableSchedule.find(undoable_schedule.id) }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'if current user does not the undoable schedule' do
      let!(:undoable_schedule) { Fabricate(:undoable_schedule) }

      it 'does not delete any UndoableSchedule record' do
        expect { subject }.not_to change { UndoableSchedule.count }
      end

      it 'returns a 403 Forbidden status' do
        expect(subject.status).to eq(403)
      end
    end
  end
end
