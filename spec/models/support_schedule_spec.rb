require 'rails_helper'

describe SupportSchedule do
  describe '.between' do
    let!(:support_order) { Fabricate(:support_order, start_at: Date.new(2014, 10, 1)) }
    let!(:next_support_order) { Fabricate(:support_order, start_at: Date.new(2014, 11, 12)) }

    subject { described_class.between(start_date, end_date) }

    context 'given only one SupportOrder applies for the provided :start_date and :end_date' do
      let(:start_date) { Date.new(2014, 10, 5) }
      let(:end_date) { Date.new(2014, 10, 17) }

      let(:support_schedules) { Fabricate.times(3, :support_schedule) }
      let(:list) { double(SupportScheduleList, all: support_schedules) }

      before do
        expect(SupportScheduleList).to receive(:new).with(support_order).and_return(list)
        expect(list).to receive(:all).with(start_date, end_date).and_return(support_schedules)
      end

      it 'returns all SupportSchedules for the one SupportOrder between the provided dates' do
        expect(subject).to eq(support_schedules)
      end

      context 'and passing in a user' do
        let(:user) { Fabricate(:user) }

        before do
          support_schedules.first.user = user
        end

        subject { described_class.between(start_date, end_date, user) }

        it 'filters the SupportSchedules and returns only those assigned to the given user' do
          expect(subject).to eq([support_schedules.first])
        end
      end
    end

    context 'given multiple consecutive SupportOrders apply for the provided :start_date and :end_date' do
      let(:start_date) { Date.new(2014, 10, 25) }
      let(:end_date) { Date.new(2014, 11, 20) }

      let(:support_schedules) { Fabricate.times(3, :support_schedule) }
      let(:list) { double(SupportScheduleList, all: support_schedules) }

      let(:next_support_schedules) { Fabricate.times(4, :support_schedule) }
      let(:next_list) { double(SupportScheduleList, all: next_support_schedules) }

      before do
        expect(SupportScheduleList).to receive(:new).with(support_order).and_return(list)
        expect(list).to receive(:all).with(start_date, next_support_order.start_at - 1.day).and_return(support_schedules)

        expect(SupportScheduleList).to receive(:new).with(next_support_order).and_return(next_list)
        expect(next_list).to receive(:all).with(next_support_order.start_at, end_date).and_return(next_support_schedules)
      end

      it 'concatenates the SupportSchedules between the given SupportOrders' do
        expect(subject).to eq(support_schedules + next_support_schedules)
      end

      context 'and passing in a user' do
        let(:user) { Fabricate(:user) }

        before do
          support_schedules.first.user = user
          next_support_schedules.last.user = user
        end

        subject { described_class.between(start_date, end_date, user) }

        it 'filters the SupportSchedules and returns only those assigned to the given user' do
          expect(subject).to eq([support_schedules.first, next_support_schedules.last])
        end
      end
    end
  end

  describe '.find' do
    let(:support_order) { Fabricate(:support_order, start_at: Date.new(2014, 11, 1)) }
    let(:user) { Fabricate(:user) }
    let(:date) { Date.new(2014, 11, 13) }

    before do
      support_order_user = support_order.support_order_users.find_by!(position: 8)
      support_order_user.update!(user: user)
    end

    it 'returns the SupportSchedule for the given date' do
      support_schedule = described_class.find(date)
      expect(support_schedule.user).to eq(user)
      expect(support_schedule.position).to eq(8)
      expect(support_schedule.date).to eq(date)
    end
  end
end
