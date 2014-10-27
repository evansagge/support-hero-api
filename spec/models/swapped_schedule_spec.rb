require 'rails_helper'

describe SwappedSchedule do
  describe '.between' do
    let!(:swapped_schedule_1) { Fabricate(:swapped_schedule, original_date: Date.new(2014, 12, 4), target_date: Date.new(2014, 12, 15)) }
    let!(:swapped_schedule_2) { Fabricate(:swapped_schedule, original_date: Date.new(2014, 12, 14), target_date: Date.new(2014, 12, 15)) }
    let!(:swapped_schedule_3) { Fabricate(:swapped_schedule, original_date: Date.new(2014, 12, 1), target_date: Date.new(2014, 12, 5)) }
    let!(:swapped_schedule_4) { Fabricate(:swapped_schedule, original_date: Date.new(2014, 12, 1), target_date: Date.new(2014, 12, 2)) }

    let(:start_date) { Date.new(2014, 12, 3) }
    let(:end_date) { Date.new(2014, 12, 10) }

    subject { described_class.between(start_date, end_date) }

    it 'includes all SwappedSchedule with original_date within the given date range' do
      expect(subject.count).to eq(2)
      expect(subject).to include(swapped_schedule_1)
    end

    it 'includes all SwappedSchedule with target_date within the given date range' do
      expect(subject.count).to eq(2)
      expect(subject).to include(swapped_schedule_3)
    end
  end
  describe 'callbacks' do
    describe 'before validation on create' do
      let(:instance) { Fabricate.build(:swapped_schedule, original_user: nil, target_user: nil) }

      subject { instance.valid? }

      before do
        allow(SupportSchedule).to receive(:find)
      end

      it 'calculates the value for #original_user based on the SupportOrder for the given #original_date' do
        original_schedule = Fabricate(:support_schedule)
        expect(SupportSchedule).to receive(:find).with(instance.original_date).and_return(original_schedule)
        expect { subject }.to change { instance.original_user }.from(nil).to(original_schedule.user)
      end

      it 'calculates the value for #target_user based on the SupportOrder for the given #target_date' do
        target_schedule = Fabricate(:support_schedule)
        expect(SupportSchedule).to receive(:find).with(instance.target_date).and_return(target_schedule)
        expect { subject }.to change { instance.target_user }.from(nil).to(target_schedule.user)
      end
    end
  end
end
