require 'rails_helper'

describe V1::UsersController do
  describe 'GET :index' do
    let!(:users) { Fabricate.times(3, :user) }

    subject { get :index }

    it 'renders successfully' do
      expect(subject.status).to eq(200)
    end

    it 'renders a JSON representation of each user' do
      expect(subject.body).to have_json_size(users.count).at_path('users')
      users.each do |user|
        expected = UserSerializer.new(user, root: false)
        expect(subject.body).to include_json(expected.to_json).at_path('users')
      end
    end
  end

  describe 'GET :show' do
    let(:user) { Fabricate(:user) }

    subject { get :show, id: user.id }

    it 'renders successfully' do
      expect(subject.status).to eq(200)
    end

    it 'renders a JSON representation of a user' do
      expected = UserSerializer.new(user, root: false)
      expect(subject.body).to be_json_eql(expected.to_json).at_path('user')
    end
  end
end
