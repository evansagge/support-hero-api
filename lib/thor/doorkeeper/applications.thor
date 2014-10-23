module Doorkeeper
  class Applications < Thor
    include Thor::Rails

    desc 'list', 'Lists all Doorkeeper applications with the client ID and secret'
    def list
      applications = ::Doorkeeper::Application.all
      applications.each do |application|
        display_application(application)
      end
    end

    desc 'create NAME REDIRECT_URI', 'Create a new Doorkeeper application given a name and a redirect URI'
    def create(name, redirect_uri = 'urn:ietf:wg:oauth:2.0:oob')
      application = ::Doorkeeper::Application.create!(name: name, redirect_uri: redirect_uri)
      display_application(application)
    end

    protected

    def display_application(application)
      puts '#' * 88
      puts <<-EOF

      Application name: #{application.name}
      Client ID:        #{application.uid}
      Client Secret:    #{application.secret}
      Redirect URI:     #{application.redirect_uri}

      EOF
    end
  end
end
