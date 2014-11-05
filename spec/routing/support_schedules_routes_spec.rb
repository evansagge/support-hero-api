require 'rails_helper'

describe 'api/v1/support_schedules' do

  specify { expect(get('api/v1/support_schedules')).to route_to('v1/support_schedules#index') }
  specify { expect(get('api/v1/support_schedules/2014-11-01')).to route_to('v1/support_schedules#show', id: '2014-11-01') }

end
