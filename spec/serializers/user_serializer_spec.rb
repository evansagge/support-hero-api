require 'rails_helper'

describe UserSerializer do
  let(:user) { Fabricate(:user) }
  let(:serializer) { described_class.new(user) }

  let(:expected) do
    {
      id:   user.id,
      name: user.name,
      roles: user.roles
    }
  end

  it 'creates a JSON representation of a User' do
    expect(serializer.to_json).to be_json_eql(expected.to_json).at_path('user')
  end
end
