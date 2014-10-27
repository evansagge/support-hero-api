require 'rails_helper'

describe SupportOrder do

  describe '.for_date' do
    let(:support_order_start) { Date.new(2014, 11, 1) }
    let!(:support_order) { Fabricate(:support_order, start_at: support_order_start) }
    let!(:older_support_order) { Fabricate(:support_order, start_at: 5.days.ago(support_order_start)) }
    let!(:much_older_support_order) { Fabricate(:support_order, start_at: 2.months.ago(support_order_start)) }
    let(:date) { Date.new(2014, 11, 5) }

    it 'returns the closest SupportOrder record before the given start date' do
      expect(described_class.for_date(Date.new(2014, 11, 5))).to eq(support_order)
      expect(described_class.for_date(Date.new(2014, 10, 29))).to eq(older_support_order)
      expect(described_class.for_date(Date.new(2014, 10, 1))).to eq(much_older_support_order)
    end
  end

  describe '#user_list' do
    let(:users) { Fabricate.times(6, :user) }
    let(:instance) { Fabricate(:support_order, start_at: Date.new(2014, 10, 1), skip_users: true) }
    let(:user_position_list) { [1, 0, 3, 4, 1, 5, 2, 1, 4, 0] }
    let!(:support_order_users) do
      user_position_list.map.with_index do |user_index, n|
        Fabricate(:support_order_user, support_order: instance, user: users[user_index], position: n + 1)
      end
    end

    it 'returns a hash of positions in the support order with the user associated with each position' do
      expected = Hash[user_position_list.map.with_index { |user_index, n| [n + 1, users[user_index]] }]
      expect(instance.user_list).to eq(expected)
    end
  end

  describe '#user_count' do
    let(:instance) { Fabricate(:support_order) }

    it 'returns the total number of users assigned for this support order' do
      expect(instance.user_count).to eq(instance.support_order_users.count)
    end
  end

  describe '#support_schedules' do
    let(:instance) { Fabricate(:support_order) }

    it 'returns a SupportScheduleList object with the support order as the past parameter' do
      support_schedules = double(SupportScheduleList)
      expect(SupportScheduleList).to receive(:new).with(instance).and_return(support_schedules)
      expect(instance.support_schedules).to eq(support_schedules)
    end
  end
end
