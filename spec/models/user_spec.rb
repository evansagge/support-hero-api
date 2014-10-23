require 'rails_helper'

describe User do
  let!(:user) { Fabricate(:user, name: 'Evan', password: 'password1', password_confirmation: 'password1') }

  describe '.authenticate' do
    it 'returns false if there is no user with the given name' do
      expect(described_class.authenticate('John', 'password1')).to be_falsey
    end

    it 'returns false if the password is invalid' do
      expect(described_class.authenticate('Evan', 'password')).to be_falsey
    end

    it 'returns the user if the user exists with the given name and the password is valid' do
      expect(described_class.authenticate('Evan', 'password1')).to eq(user)
    end
  end

  context 'roles' do
    describe '#manager?' do
      it 'returns true if a user has a "manager" role' do
        manager = Fabricate(:user, roles: %w(manager))
        expect(manager).to be_manager

        not_manager = Fabricate(:user, roles: [])
        expect(not_manager).to_not be_manager
      end
    end

    describe '#support?' do
      it 'returns true if a user has a "support" role' do
        support = Fabricate(:user, roles: %w(support))
        expect(support).to be_support

        not_support = Fabricate(:user, roles: [])
        expect(not_support).to_not be_support
      end
    end
  end
end
