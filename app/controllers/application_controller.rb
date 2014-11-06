class ApplicationController < ActionController::API
  include ActionController::Serialization
  include AbstractController::Callbacks
  include ActionController::Head
  include Doorkeeper::Helpers::Filter
  include Pundit
  include HasScope

  rescue_from Pundit::NotAuthorizedError, with: :pundit_not_authorized

  doorkeeper_for :all

  api :POST, 'oauth/token', 'OAuth2 token authentication endpoint. ' \
    'Post here with authorization code for authorization code grant type or ' \
    'username and password for password grant type, or refresh token for refresh token type. ' \
    'This corresponds to the token endpoint, section 3.2 of the OAuth 2 RFC.'
  api :GET, 'oauth/token/info', 'Shows details about the token used for authentication'
  api :POST, 'oauth/token/revoke', 'Revokes the given token, requires authentication'

  api :GET, 'oauth/authorize/:code'
  api :POST, 'oauth/authorize'
  api :DELETE, 'oauth/authorize'

  protected

  def doorkeeper_unauthorized_render_options
    { json: { status: :failure, message: '401 Unauthorized' }.to_json }
  end

  def pundit_not_authorized
    render json: { status: :failure, message: '403 Forbidden' }, status: :forbidden
  end

  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
