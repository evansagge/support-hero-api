require 'rails_helper'

describe SupportScheduleList do
  let(:support_order_start) { Date.new(2014, 11, 1) }
  let!(:support_order) { Fabricate(:support_order, start_at: support_order_start) }
  let(:start_date) { Date.new(2014, 11, 5) }
  let(:instance) { described_class.new(start_date) }

  describe '#all' do
    context 'given no user' do
      subject { instance.all }

      it 'return all schedules for all business days from the given start date until the end of the month, ' \
        'taking into consideration weekends and holidays' do
        # Calculate holidays
        Holidays.between(start_date, start_date.end_of_month, :us, :us_ca).map do |holiday|
          BusinessTime::Config.holidays << holiday[:date]
        end

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
    end

    context 'given a specific user' do
      let(:user) { support_order.users.first }
      let(:positions) { [1, 5, 8] }

      subject { instance.all(user) }

      it 'return all schedules for the given user for all business days from the given start ' \
        'date until the end of the month, taking into consideration weekends and holidays' do
        # Calculate holidays
        Holidays.between(start_date, start_date.end_of_month, :us, :us_ca).map do |holiday|
          BusinessTime::Config.holidays << holiday[:date]
        end

        expect(subject.count).to eq(4)
        day_and_position_map = { 7 => 5, 13 => 8, 18 => 1, 24 => 5 }
        day_and_position_map.each_with_index do |day_position, n|
          day, position = day_position
          date = Date.new(2014, 11, day)
          support_schedule = subject[n]
          expect(support_schedule).to be_a(SupportSchedule)
          expect(support_schedule.position).to eq(position)
          expect(support_schedule.user).to eq(user)
          expect(support_schedule.date).to eq(date)
        end
      end
    end
  end

  describe '#find_by_date' do
    context 'given a date within the number of days equal to the number of support users' do
      let(:date) { Date.new(2014, 11, 13) }
      subject { instance.find_by_date(date) }

      it 'returns the SupportSchedule object for the given date, taking into consideration weekends and holidays' do
        expected_position = 8 # Nov. 13, 2014 is 8 business days from Nov. 1, 2014
        support_order_user = support_order.support_order_users.where(position: expected_position).first!
        expect(subject.position).to eq(expected_position)
        expect(subject.user).to eq(support_order_user.user)
        expect(subject.date).to eq(date)
      end
    end

    context 'given a date past the number of days equal to the number of support users' do
      let(:date) { Date.new(2014, 11, 25) }
      subject { instance.find_by_date(date) }

      it 'rotates back to
      Holithe start of the support order list to determine the support user for that date' do
        expected_position = 6 # Nov. 13, 2014 is 16 business days from Nov. 1, 2014, 6 more than the total number of support users
        support_order_user = support_order.support_order_users.where(position: expected_position).first!
        expect(subject.position).to eq(expected_position)
        expect(subject.user).to eq(support_order_user.user)
        expect(subject.date).to eq(date)
      end
    end
  end

  describe '#support_order' do
    let!(:older_support_order) { Fabricate(:support_order, start_at: 2.days.ago(support_order_start)) }

    it 'returns the closest SupportOrder record before the given start date' do
      expect(instance.support_order).to eq(support_order)
    end
  end
end
