require 'rails_helper'

describe V1::UsersController do
  let(:user) { Fabricate(:user) }
  let(:token) { double(Doorkeeper::AccessToken, acceptable?: true, resource_owner_id: user.id) }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe 'GET :index' do
    let!(:users) { Fabricate.times(3, :user) }

    subject { get :index }

    it 'renders successfully' do
      expect(subject.status).to eq(200)
    end

    it 'renders a JSON representation of each user' do
      expect(subject.body).to have_json_size(User.count).at_path('users')
      User.all.each do |user|
        expected = UserSerializer.new(user, root: false)
        expect(subject.body).to include_json(expected.to_json).at_path('users')
      end
    end
  end

  describe 'GET :show' do
    let(:user) { Fabricate(:user) }

    subject { get :show, id: user.id }

    it 'renders successfully' do
      expect(subject.status).to eq(200)
    end

    it 'renders a JSON representation of a user' do
      expected = UserSerializer.new(user)
      expect(subject.body).to be_json_eql(expected.to_json)
    end
  end

  describe 'PUT :update' do
    context 'if user is the same as the current user' do
      subject { put :update, id: user.id, user: { password: 'Password1', password_confirmation: 'Password1' } }

      it 'updates the User record' do
        expect { subject }.to change { user.reload.updated_at }
      end

      it 'renders successfully' do
        expect(subject.status).to eq(200)
      end
    end

    context 'if user is not the current user' do
      let(:another_user) { Fabricate(:user) }

      subject { put :update, id: another_user.id, user: { password: 'Password1', password_confirmation: 'Password1' } }

      it 'does not update the User record' do
        expect { subject }.not_to change { user.reload.updated_at }
      end

      it 'returns a 403 Forbidden status' do
        expect(subject.status).to eq(403)
      end
    end
  end
end
