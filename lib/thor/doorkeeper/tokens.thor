module Doorkeeper
  class Tokens < Thor
    include Thor::Rails

    desc 'create APPLICATION_NAME USERNAME', 'Creates a new access token'
    def create(application_name, username)
      application = Doorkeeper::Application.find_by(name: application_name)
      user = User.find_by(name: username)
      access_token = Doorkeeper::AccessToken.create!(
        resource_owner_id: user.id,
        application_id:    application.id,
        expires_in:        7200,
        use_refresh_token: true
      )

      puts '#' * 88
      puts <<-EOF

      Access token:  #{access_token.token}
      Refresh Token: #{access_token.refresh_token}
      Expires At:    #{access_token.expires_in.since(access_token.created_at)}

      EOF
    end
  end
end
