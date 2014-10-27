require 'rails_helper'

describe V1::SupportSchedulesController do
  include ActiveSupport::Testing::TimeHelpers

  let(:user) { Fabricate(:user) }
  let(:token) { double(Doorkeeper::AccessToken, acceptable?: true, resource_owner_id: user.id) }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe 'GET :index' do
    around do |example|
      travel_to(Date.new(2014, 10, 27)) { example.run }
    end

    let(:support_schedules) { Fabricate.build_times(3, :support_schedule) }
    let(:schedule_list) { double(SupportScheduleList, all: support_schedules) }
    let(:users) { Fabricate.times(6, :user) }
    let!(:support_order) { Fabricate(:support_order, start_at: Date.new(2014, 10, 1), skip_users: true) }
    let!(:support_order_users) do
      user_position_list = [1, 0, 3, 4, 1, 5, 2, 1, 4, 0]
      user_position_list.map.with_index do |user_index, n|
        Fabricate(
          :support_order_user,
          support_order: support_order,
          user:          users[user_index],
          position:      n + 1
        )
      end
    end

    subject { get :index }

    it 'renders successfully' do
      expect(subject.status).to eq(200)
    end

    context 'without any additional parameter' do
      it 'passes the current month\'s beginning and end dates as parameters to SupportSchedule.between' do
        date = Date.today
        expect(SupportSchedule).to receive(:between).with(date.beginning_of_month, date.end_of_month, nil)
        subject
      end

      it 'renders the JSON representation for each support schedule for the current month' do
        expect(subject.body).to have_json_size(22).at_path('support_schedules')
        {
          1 => 1, 2 => 2, 3 => 3, 6 => 4, 7 => 5, 8 => 6, 9 => 7, 10 => 8, 14 => 9, 15 => 10,
          16 => 1, 17 => 2, 20 => 3, 21 => 4, 22 => 5, 23 => 6, 24 => 7, 27 => 8, 28 => 9, 29 => 10,
          30 => 1, 31 => 2
        }.each do |day, position|
          support_order_user = support_order.support_order_users.find_by!(position: position)
          support_schedule = SupportSchedule.new(user: support_order_user.user, position: position, date: Date.new(2014, 10, day))
          expected = SupportScheduleSerializer.new(support_schedule, root: false)
          expect(subject.body).to include_json(expected.to_json).at_path('support_schedules')
        end
      end
    end

    context 'with a :user_id parameter' do
      let(:user) { Fabricate(:user) }
      subject { get :index, user_id: user.id }

      before do
        support_order.support_order_users.where(position: [1, 5, 8]).update_all(user_id: user.id)
      end

      it 'passes the current month\'s beginning and end dates as parameters to SupportSchedule.between' do
        date = Date.today
        expect(SupportSchedule).to receive(:between).with(date.beginning_of_month, date.end_of_month, user)
        subject
      end

      it 'renders the JSON representation for each support schedule for the current month for the provided user' do
        expect(subject.body).to have_json_size(7).at_path('support_schedules')
        { 1 => 1, 7 => 5, 10 => 8, 16 => 1, 22 => 5, 27 => 8, 30 => 1 }.each do |day, position|
          support_schedule = SupportSchedule.new(user: user, position: position, date: Date.new(2014, 10, day))
          expected = SupportScheduleSerializer.new(support_schedule, root: false)
          expect(subject.body).to include_json(expected.to_json).at_path('support_schedules')
        end
      end
    end

    context 'with :start_date and :end_date parameters' do
      subject { get :index, start_date: '2014-11-1', end_date: '2014-11-12' }

      it 'passes the date for the beginning of the provided month and year as parameter for SupportScheduleList' do
        expect(SupportSchedule).to receive(:between).with(Date.new(2014, 11, 1), Date.new(2014, 11, 12), nil)
        subject
      end

      it 'renders the JSON representation for each support schedule for the current month' do
        expect(subject.body).to have_json_size(7).at_path('support_schedules')
        { 3 => 3, 4 => 4, 5 => 5, 6 => 6, 7 => 7, 10 => 8, 12 => 9 }.each do |day, position|
          support_order_user = support_order.support_order_users.find_by!(position: position)
          support_schedule = SupportSchedule.new(user: support_order_user.user, position: position, date: Date.new(2014, 11, day))
          expected = SupportScheduleSerializer.new(support_schedule, root: false)
          expect(subject.body).to include_json(expected.to_json).at_path('support_schedules')
        end
      end
    end

    context 'with :user_id, :month, and :year parameters' do
      let(:user) { Fabricate(:user) }
      subject { get :index, user_id: user.id, start_date: '2014-11-1', end_date: '2014-11-10' }

      before do
        support_order.support_order_users.where(position: [1, 5, 8]).update_all(user_id: user.id)
      end

      it 'passes the date for the beginning of the provided month and year as parameter for SupportScheduleList' do
        expect(SupportSchedule).to receive(:between).with(Date.new(2014, 11, 1), Date.new(2014, 11, 10), user)
        subject
      end

      it 'renders the JSON representation for each support schedule for the current month' do
        expect(subject.body).to have_json_size(2).at_path('support_schedules')
        { 5 => 5, 10 => 8 }.each do |day, position|
          support_order_user = support_order.support_order_users.find_by!(position: position)
          support_schedule = SupportSchedule.new(user: support_order_user.user, position: position, date: Date.new(2014, 11, day))
          expected = SupportScheduleSerializer.new(support_schedule, root: false)
          expect(subject.body).to include_json(expected.to_json).at_path('support_schedules')
        end
      end
    end
  end

  describe 'GET :show' do
    let(:support_order) { Fabricate(:support_order, start_at: Date.new(2014, 11, 1)) }
    let(:user) { Fabricate(:user) }
    let(:id) { '2014-11-13' }
    let(:date) { Date.parse(id) }
    let(:support_schedule) { Fabricate.build(:support_schedule, date: date, user: user, position: 8) }

    before do
      support_order_user = support_order.support_order_users.find_by!(position: 8)
      support_order_user.update!(user: user)
    end

    subject { get :show, id: id }

    it 'renders successfully' do
      expect(subject.status).to eq(200)
    end

    it 'renders a JSON representation of a schedule' do
      expected = SupportScheduleSerializer.new(support_schedule, root: false)
      expect(subject.body).to be_json_eql(expected.to_json).at_path('support_schedule')
    end
  end
end
