require 'rails_helper'

describe User do
  let!(:user) { Fabricate(:user, name: 'Evan', password: 'password1', password_confirmation: 'password1') }

  describe '#authenticate' do
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
end
