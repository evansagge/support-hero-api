require 'rails_helper'

describe UndoableSchedulePolicy do
  subject { described_class }

  permissions :create? do
    let(:support_order) { Fabricate(:support_order, start_at: Date.new(2014, 11, 1)) }
    let(:date) { Date.new(2014, 11, 5) }
    let(:user) { Fabricate(:user) }
    let(:undoable_schedule) { Fabricate.build(:undoable_schedule, user: user, date: date) }

    it 'grants access if user is a manager' do
      manager = Fabricate(:user, roles: %w(manager))
      expect(subject).to permit(manager, undoable_schedule)
    end

    it 'grants access if user is scheduled for support on that date' do
      support_order_user = support_order.support_order_users.find_by(position: 3)
      support_order_user.update!(user: user)
      expect(subject).to permit(user, undoable_schedule)
    end

    it 'denies access if user is neither a manager nor scheduled for support on that date' do
      expect(subject).to_not permit(user, undoable_schedule)
    end
  end

  permissions :destroy? do
    let(:user) { Fabricate(:user) }
    let(:undoable_schedule) { Fabricate(:undoable_schedule, user: user) }

    it 'grants access if user is a manager' do
      manager = Fabricate(:user, roles: %w(manager))
      expect(subject).to permit(manager, undoable_schedule)
    end

    it 'grants access if user owns the undoable schedule' do
      expect(subject).to permit(user, undoable_schedule)
    end

    it 'denies access if user neither owns the undoable schedule nor is a manager' do
      expect(subject).to_not permit(Fabricate(:user), undoable_schedule)
    end
  end
end
