Apipie.configure do |config|
  config.app_name                = 'Support Hero API'
  config.copyright               = '&copy; 2014 Evan Sagge'
  config.api_base_url            = '/api/'
  config.doc_base_url            = '/docs'
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
end

class DateValidator < Apipie::Validator::BaseValidator
  def initialize(param_description, argument)
    super(param_description)
    @type = argument
  end

  def validate(value)
    return false if value.nil?
    Chronic.parse(value).present?
  end

  def self.build(param_description, argument, _options, _block)
    new(param_description, argument) if argument == Date
  end

  def description
    "Must be a #{@date} in the format YYYY-MM-DD."
  end
end
