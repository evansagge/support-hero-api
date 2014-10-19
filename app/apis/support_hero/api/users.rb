module SupportHero
  module API
    class Users < Grape::API
      include APIDefaults

      resource :users do
        desc 'Return all users'
        get '', root: :users do
          User.all
        end

        desc 'Return a user given an ID'
        params do
          requires :id, type: String, desc: 'ID of the user'
        end
        get ':id', root: 'user' do
          User.find(params[:id])
        end
      end
    end
  end
end

