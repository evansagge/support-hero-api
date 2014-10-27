require 'rails_helper'

describe 'v1/current_user' do

  specify { expect(get('v1/current_user')).to route_to('v1/current_user#show') }

end
