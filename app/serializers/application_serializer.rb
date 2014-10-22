class ApplicationSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  def default_url_options
    { host: ENV.fetch('URL_HOST'), protocol: ENV.fetch('URL_PROTOCOL') }
  end
end
