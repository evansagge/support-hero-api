require 'rails_helper'

describe 'v1/undoable_schedules' do

  specify { expect(get('api/v1/undoable_schedules')).to route_to('v1/undoable_schedules#index') }
  specify { expect(post('api/v1/undoable_schedules')).to route_to('v1/undoable_schedules#create') }
  specify { expect(get('api/v1/undoable_schedules/123abc')).to route_to('v1/undoable_schedules#show', id: '123abc') }
  specify { expect(put('api/v1/undoable_schedules/123abc')).to route_to('v1/undoable_schedules#update', id: '123abc') }
  specify { expect(delete('api/v1/undoable_schedules/123abc')).to route_to('v1/undoable_schedules#destroy', id: '123abc') }

end
