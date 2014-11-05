require 'rails_helper'

describe 'api/v1/swapped_schedules' do

  specify { expect(get('api/v1/swapped_schedules')).to route_to('v1/swapped_schedules#index') }
  specify { expect(post('api/v1/swapped_schedules')).to route_to('v1/swapped_schedules#create') }
  specify { expect(get('api/v1/swapped_schedules/123abc')).to route_to('v1/swapped_schedules#show', id: '123abc') }
  specify { expect(put('api/v1/swapped_schedules/123abc')).to route_to('v1/swapped_schedules#update', id: '123abc') }
  specify { expect(delete('api/v1/swapped_schedules/123abc')).to route_to('v1/swapped_schedules#destroy', id: '123abc') }

end
