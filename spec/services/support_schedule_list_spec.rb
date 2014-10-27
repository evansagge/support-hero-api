require 'rails_helper'

describe SupportScheduleList do
  let(:support_order_start) { Date.new(2014, 11, 1) }
  let!(:support_order) { Fabricate(:support_order, start_at: support_order_start) }
  let(:instance) { described_class.new(support_order) }

  before do
    # Calculate holidays
    BusinessTime::Config.holidays = [
      Date.new(2014, 11, 11), # Veteran's Day
      Date.new(2014, 11, 27), # Thanksgiving Day
      Date.new(2014, 11, 28)  # Day after Thanksgiving
    ]
  end

  describe '#all' do
    let(:start_date) { Date.new(2014, 11, 5) }
    let(:end_date) { Date.new(2014, 11, 30) }

    subject { instance.all(start_date, end_date) }

    it 'return all schedules for all business days from the given start date until the end of the month, ' \
      'taking into consideration weekends and holidays' do
      expect(subject.count).to eq(15)
      expected_position_order = (3..10).to_a + (1..7).to_a
      expected_position_order.each_with_index do |position, n|
        date = n.business_days.since(start_date)
        support_order_user = support_order.support_order_users.where(position: position).first!

        support_schedule = subject[n]
        expect(support_schedule).to be_a(SupportSchedule)
        expect(support_schedule.position).to eq(position)
        expect(support_schedule.user).to eq(support_order_user.user)
        expect(support_schedule.date).to eq(date)
      end
    end

    describe 'given undoable schedules' do
      before do
        Fabricate(:undoable_schedule, date: Date.new(2014, 11, 6), approved: true)
        Fabricate(:undoable_schedule, date: Date.new(2014, 11, 19), approved: true)
      end

      it 'takes into consideration approved undoable schedules within the range of the schedule list' do
        expect(subject.count).to eq(13)
        expect(subject.map(&:date)).to_not include(Date.new(2014, 11, 6))
        expect(subject.map(&:date)).to_not include(Date.new(2014, 11, 19))
      end
    end
  end

  describe '#find' do
    context 'given a date within the number of days equal to the number of support users' do
      let(:date) { Date.new(2014, 11, 13) }
      subject { instance.find(date) }

      it 'returns the SupportSchedule object for the given date, taking into consideration weekends and holidays' do
        expected_position = 8 # Nov. 13, 2014 is 8 business days from Nov. 1, 2014
        support_order_user = support_order.support_order_users.where(position: expected_position).first!
        expect(subject.position).to eq(expected_position)
        expect(subject.user).to eq(support_order_user.user)
        expect(subject.date).to eq(date)
      end

      describe 'given undoable schedules' do
        before do
          Fabricate(:undoable_schedule, date: Date.new(2014, 11, 6), approved: true)
          Fabricate(:undoable_schedule, date: Date.new(2014, 11, 19), approved: true)
        end

        it 'takes into consideration approved undoable schedules within the range of the schedule list' do
          expected_position = 7
          # Nov. 13, 2014 is 8 business days from Nov. 1, 2014,
          # but we skipped 1 day on Nov. 6
          support_order_user = support_order.support_order_users.where(position: expected_position).first!
          expect(subject.position).to eq(expected_position)
          expect(subject.user).to eq(support_order_user.user)
          expect(subject.date).to eq(date)
        end
      end
    end

    context 'given a date past the number of days equal to the number of support users' do
      let(:date) { Date.new(2014, 11, 25) }
      subject { instance.find(date) }

      it 'rotates back to the start of the support order list to determine the support user for that date' do
        expected_position = 6
        # Nov. 13, 2014 is 16 business days from Nov. 1, 2014,
        # 6 more than the total number of support users
        support_order_user = support_order.support_order_users.where(position: expected_position).first!
        expect(subject.position).to eq(expected_position)
        expect(subject.user).to eq(support_order_user.user)
        expect(subject.date).to eq(date)
      end

      describe 'given undoable schedules' do
        before do
          Fabricate(:undoable_schedule, date: Date.new(2014, 11, 6), approved: true)
          Fabricate(:undoable_schedule, date: Date.new(2014, 11, 19), approved: true)
        end

        it 'takes into consideration approved undoable schedules within the range of the schedule list' do
          expected_position = 4
          # Nov. 13, 2014 is 16 business days from Nov. 1, 2014,
          # 6 more than the total number of support users,
          # but we skipped 2 days on Nov. 6 and Nov. 19
          support_order_user = support_order.support_order_users.where(position: expected_position).first!
          expect(subject.position).to eq(expected_position)
          expect(subject.user).to eq(support_order_user.user)
          expect(subject.date).to eq(date)
        end
      end
    end
  end
end
