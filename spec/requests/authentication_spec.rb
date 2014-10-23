require 'rails_helper'

describe 'API authentication' do
  describe 'unauthenticated access' do
    it 'returns with a 401 error' do
      get 'v1/support_schedules'
      expect(response.status).to eq(401)
      expect(response.body).to be_json_eql({ status: 'failure', message: '401 Unauthorized' }.to_json)
    end
  end
end
