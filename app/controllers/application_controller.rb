class ApplicationController < ActionController::API
  include ActionController::Serialization
  include AbstractController::Callbacks
  include ActionController::Head
  include Doorkeeper::Helpers::Filter

  doorkeeper_for :all

  protected

  def doorkeeper_unauthorized_render_options
    { json: '{"status": "failure", "message":"401 Unauthorized"}' }
  end

  def current_user
    @current_user ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end
end
