require 'rails_helper'

describe UserPolicy do
  subject { described_class }

  permissions :update? do
    let(:user) { Fabricate(:user) }

    it 'grants access if user is the same user' do
      expect(subject).to permit(user, user)
    end

    it 'denies access if user is not the same user' do
      expect(subject).to_not permit(Fabricate(:user), user)
    end
  end
end
