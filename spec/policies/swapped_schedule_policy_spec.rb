require 'rails_helper'

describe SwappedSchedulePolicy do
  # let(:support_order) { Fabricate(:support_order, start_at: Date.new(2014, 11, 1)) }
  let(:original_date) { Date.new(2014, 11, 5) }
  let(:original_user) { Fabricate(:user) }
  let(:target_date) { Date.new(2014, 11, 12) }
  let(:target_user) { Fabricate(:user) }

  subject { described_class }

  permissions :create? do
    # let(:user) { original_user }
    let(:swapped_schedule) do
      Fabricate.build(
        :swapped_schedule,
        original_date: original_date,
        original_user: original_user,
        target_date:   target_date,
        target_user:   target_user
      )
    end
    #
    # it 'grants access if user is scheduled for support on the original date' do
    #   support_order_user = support_order.support_order_users.find_by(position: 3)
    #   support_order_user.update!(user: user)
    #
    #   expect(subject).to permit(user, swapped_schedule)
    # end
    #
    # it 'denies access if user is not scheduled for support on the original date' do
    #   expect(subject).to_not permit(original_user, swapped_schedule)
    #   expect(subject).to_not permit(target_user, swapped_schedule)
    #   expect(subject).to_not permit(Fabricate(:user), swapped_schedule)
    # end
    it 'grants access if user is the original user' do
      expect(subject).to permit(original_user, swapped_schedule)
    end

    it 'denies access if user is the target user' do
      expect(subject).to_not permit(target_user, swapped_schedule)
    end

    it 'denies access if user is any other user' do
      expect(subject).to_not permit(Fabricate(:user), swapped_schedule)
    end
  end

  permissions :update? do
    let(:swapped_schedule) do
      Fabricate(
        :swapped_schedule,
        original_date: original_date,
        original_user: original_user,
        target_date:   target_date,
        target_user:   target_user
      )
    end

    it 'grants access if user is the target user' do
      expect(subject).to permit(target_user, swapped_schedule)
    end

    it 'denies access if user is the original user' do
      expect(subject).to_not permit(original_user, swapped_schedule)
    end

    it 'denies access if user is any other user' do
      expect(subject).to_not permit(Fabricate(:user), swapped_schedule)
    end
  end

  permissions :destroy? do
    let(:swapped_schedule) do
      Fabricate(
        :swapped_schedule,
        original_date: original_date,
        original_user: original_user,
        target_date:   target_date,
        target_user:   target_user
      )
    end

    it 'grants access if user is the original user' do
      expect(subject).to permit(original_user, swapped_schedule)
    end

    it 'denies access if user is the target user' do
      expect(subject).to_not permit(target_user, swapped_schedule)
    end

    it 'denies access if user is any other user' do
      expect(subject).to_not permit(Fabricate(:user), swapped_schedule)
    end
  end
end
