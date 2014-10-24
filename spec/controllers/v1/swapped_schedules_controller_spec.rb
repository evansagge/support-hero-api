require 'rails_helper'

describe V1::SwappedSchedulesController do
  let(:user) { Fabricate(:user) }
  let(:token) { double(Doorkeeper::AccessToken, acceptable?: true, resource_owner_id: user.id) }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe 'GET :index' do
    let!(:swapped_schedules) { Fabricate.times(5, :swapped_schedule) }

    subject { get :index }

    it 'returns a list of swapped schedules' do
      expect(subject.body).to have_json_size(5).at_path('swapped_schedules')
      swapped_schedules.each do |swapped_schedule|
        expected = SwappedScheduleSerializer.new(swapped_schedule, root: false)
        expect(subject.body).to include_json(expected.to_json).at_path('swapped_schedules')
      end
    end
  end

  describe 'POST :create' do
    let(:support_order) { Fabricate(:support_order, start_at: Date.new(2014, 11, 1)) }
    let(:date) { Date.new(2014, 11, 5) }
    let(:swapped_schedule_attributes) { { original_date: date, target_date: Date.new(2014, 11, 12) } }

    subject { post :create, swapped_schedule: swapped_schedule_attributes }

    context 'if current user is scheduled for support on the provided date' do

      before do
        support_order_user = support_order.support_order_users.find_by(position: 3)
        support_order_user.update!(user: user)
      end

      it 'returns a 200 Success status' do
        expect(subject.status).to eq(200)
      end

      it 'creates a new SwappedSchedule record' do
        expect { subject }.to change { SwappedSchedule.count }.by(1)
      end
    end

    context 'if current user is not scheduled for support on the provided date' do
      it 'does not create any SwappedSchedule record' do
        expect { subject }.not_to change { SwappedSchedule.count }
      end

      it 'returns a 403 Forbidden status' do
        expect(subject.status).to eq(403)
      end
    end
  end

  describe 'GET :show' do
    let(:swapped_schedule) { Fabricate(:swapped_schedule) }

    subject { get :show, id: swapped_schedule.id }

    it 'returns a JSON representation of the swapped schedule' do
      expected = SwappedScheduleSerializer.new(swapped_schedule)
      expect(subject.body).to be_json_eql(expected.to_json)
    end
  end

  describe 'PUT :update' do
    context 'if current user is the target user for the swapped schedule' do
      let!(:swapped_schedule) { Fabricate(:swapped_schedule, target_user: user) }

      subject { put :update, id: swapped_schedule.id, swapped_schedule: { status: 'accepted' } }

      it 'allows them to approve the swap' do
        expect { subject }.to change { swapped_schedule.reload.status }.from('pending').to('accepted')
      end
    end

    context 'if current user is the original user for the swapped schedule' do
      let!(:swapped_schedule) { Fabricate(:swapped_schedule, original_user: user) }

      subject { put :update, id: swapped_schedule.id, swapped_schedule: { status: 'approved' } }

      it 'returns a 403 Forbidden status' do
        expect(subject.status).to eq(403)
      end
    end

    context 'if current user is any other user' do
      let!(:swapped_schedule) { Fabricate(:swapped_schedule) }

      subject { put :update, id: swapped_schedule.id, swapped_schedule: { status: 'approved' } }

      it 'returns a 403 Forbidden status' do
        expect(subject.status).to eq(403)
      end
    end
  end

  describe 'DELETE :destroy' do
    subject { delete :destroy, id: swapped_schedule.id }

    context 'if current user is the original user the swapped schedule' do
      let!(:swapped_schedule) { Fabricate(:swapped_schedule, original_user: user) }

      it 'returns a 200 Success status' do
        expect(subject.status).to eq(200)
      end

      it 'deletes the SwappedSchedule record' do
        expect { subject }.to change { SwappedSchedule.count }.by(-1)
        expect { SwappedSchedule.find(swapped_schedule.id) }.to raise_error ActiveRecord::RecordNotFound
      end
    end

    context 'if current user is not the original user for the swapped schedule' do
      let!(:swapped_schedule) { Fabricate(:swapped_schedule) }

      it 'does not delete any SwappedSchedule record' do
        expect { subject }.not_to change { SwappedSchedule.count }
      end

      it 'returns a 403 Forbidden status' do
        expect(subject.status).to eq(403)
      end
    end
  end
end
