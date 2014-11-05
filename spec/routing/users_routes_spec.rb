require 'rails_helper'

describe 'api/v1/users' do

  specify { expect(get('api/v1/users')).to route_to('v1/users#index') }
  specify { expect(get('api/v1/users/some-uuid')).to route_to('v1/users#show', id: 'some-uuid') }
  specify { expect(put('api/v1/users/some-uuid')).to route_to('v1/users#update', id: 'some-uuid') }
  specify { expect(get('api/v1/users/me')).to route_to('v1/current_user#show') }

end
