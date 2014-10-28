require 'rails_helper'

describe V1::CurrentUserController do
  let(:user) { Fabricate(:user) }
  let(:token) { double(Doorkeeper::AccessToken, acceptable?: true, resource_owner_id: user.id) }

  before do
    allow(controller).to receive(:doorkeeper_token) { token }
  end

  describe 'GET :show' do
    subject { get :show }

    it 'returns the currently logged in user in its serialized JSON form' do
      expected = UserSerializer.new(user, root: :user)
      expect(subject.body).to be_json_eql(expected.to_json)
    end
  end
end
