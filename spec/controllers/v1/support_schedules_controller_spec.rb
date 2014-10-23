require 'rails_helper'

describe V1::SupportSchedulesController do
  let(:user) { Fabricate(:user) }
  let(:token) { double(Doorkeeper::AccessToken, acceptable?: true, resource_owner_id: user.id) }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe 'GET :index' do
    let(:support_schedules) { Fabricate.build_times(3, :support_schedule) }
    let(:schedule_list) { double(SupportScheduleList, all: support_schedules) }

    before do
      allow(SupportScheduleList).to receive(:new).and_return(schedule_list)
    end

    subject { get :index }

    it 'renders successfully' do
      expect(subject.status).to eq(200)
    end

    it 'renders a JSON representation of each support schedule' do
      expect(subject.body).to have_json_size(support_schedules.size).at_path('support_schedules')
      support_schedules.each do |support_schedule|
        expected = SupportScheduleSerializer.new(support_schedule, root: false)
        expect(subject.body).to include_json(expected.to_json).at_path('support_schedules')
      end
    end

    context 'without any additional parameter' do
      it 'passes the current date as parameter for SupportScheduleList' do
        date = Date.today
        expect(SupportScheduleList).to receive(:new).with(date).and_return(schedule_list)
        subject
      end
    end

    context 'with a :user_id parameter' do
      let(:user) { Fabricate(:user) }

      subject { get :index, user_id: user.id }

      it 'passes the current date as parameter for SupportScheduleList' do
        date = Date.today
        expect(SupportScheduleList).to receive(:new).with(date).and_return(schedule_list)
        subject
      end

      it 'passes the user with the given id as parameter for SupportScheduleList#all' do
        subject
        expect(schedule_list).to have_received(:all).with(user)
      end
    end

    context 'with :month and :year parameters' do
      let(:month) { 10 }
      let(:year) { 2014 }

      subject { get :index, month: month, year: year }

      it 'passes the date for the beginning of the provided month and year as parameter for SupportScheduleList' do
        date = Date.new(year, month)
        expect(SupportScheduleList).to receive(:new).with(date).and_return(schedule_list)
        subject
      end
    end

    context 'with :user_id, :month, and :year parameters' do
      let(:user) { Fabricate(:user) }
      let(:month) { 10 }
      let(:year) { 2014 }

      subject { get :index, user_id: user.id, month: month, year: year }

      it 'passes the date for the beginning of the provided month and year as parameter for SupportScheduleList' do
        date = Date.new(year, month)
        expect(SupportScheduleList).to receive(:new).with(date).and_return(schedule_list)
        subject
      end

      it 'passes the user with the given id as parameter for SupportScheduleList#all' do
        subject
        expect(schedule_list).to have_received(:all).with(user)
      end
    end
  end

  describe 'GET :show' do
    let(:support_schedule) { Fabricate.build(:support_schedule) }
    let(:schedule_list) { double(SupportScheduleList, find_by_date: support_schedule) }
    let(:id) { '2014-11-01' }
    let(:date) { Date.new(2014, 11, 1) }

    before do
      allow(SupportScheduleList).to receive(:new).with(date).and_return(schedule_list)
    end

    subject { get :show, id: id }

    it 'renders successfully' do
      expect(subject.status).to eq(200)
    end

    it 'finds the schedule from the schedule list for the given date' do
      subject
      expect(schedule_list).to have_received(:find_by_date).with(date)
    end

    it 'renders a JSON representation of a schedule' do
      expected = SupportScheduleSerializer.new(support_schedule, root: false)
      expect(subject.body).to be_json_eql(expected.to_json).at_path('support_schedule')
    end
  end
end
