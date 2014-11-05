class ApplicationController < ActionController::API
  include ActionController::Serialization
  include AbstractController::Callbacks
  include ActionController::Head
  include Doorkeeper::Helpers::Filter
  include Pundit
  include HasScope
  include Swagger::Docs::Methods

  rescue_from Pundit::NotAuthorizedError, with: :pundit_not_authorized

  doorkeeper_for :all

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
