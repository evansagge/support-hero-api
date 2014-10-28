require 'rails_helper'

describe 'v1/users' do

  specify { expect(get('v1/users')).to route_to('v1/users#index') }
  specify { expect(get('v1/users/some-uuid')).to route_to('v1/users#show', id: 'some-uuid') }
  specify { expect(put('v1/users/some-uuid')).to route_to('v1/users#update', id: 'some-uuid') }
  specify { expect(get('v1/users/me')).to route_to('v1/current_user#show') }

end
