require 'rails_helper'

describe Doorkeeper::TokensController do
  let(:application) { Doorkeeper::Application.create!(name: 'client', redirect_uri: 'urn:ietf:wg:oauth:2.0:oob') }
  let(:user) { Fabricate(:user, name: 'Evan') }

  describe 'POST :create' do
    context 'passing a valid user name and a password' do
      subject do
        post :create, client_id: application.uid, client_secret: application.secret, grant_type: :password,
          username: user.name, password: 'Pass1234'
      end

      it 'generates a new access token' do
        expect { subject }.to change { Doorkeeper::AccessToken.count }.by(1)
      end

      it 'returns the access token' do
        result = subject.body
        access_token = Doorkeeper::AccessToken.last
        expected = {
          access_token:  access_token.token,
          refresh_token: access_token.refresh_token,
          token_type:    :bearer,
          expires_in:    7200
        }
        expect(result).to be_json_eql(expected.to_json)
      end
    end
  end
end
