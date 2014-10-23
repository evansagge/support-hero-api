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
end
