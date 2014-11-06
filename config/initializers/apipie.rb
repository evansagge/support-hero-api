Apipie.configure do |config|
  config.app_name                = 'Support Hero API'
  config.copyright               = '&copy; 2014 Evan Sagge'
  config.api_base_url            = '/api/'
  config.doc_base_url            = '/docs'
  # where is your API defined?
  config.api_controllers_matcher = "#{Rails.root}/app/controllers/**/*.rb"
  config.validate                = false
end

class DateValidator < Apipie::Validator::BaseValidator
  attr_reader :type, :options

  def initialize(param_description, argument, options)
    super(param_description)
    @type = argument
    @options = options
  end

  def validate(value)
    return options[:allow_nil] == true if value.blank?
    Chronic.parse(value).present?
  end

  def self.build(param_description, argument, options, _block)
    new(param_description, argument, options) if argument == Date
  end

  def description
    "Must be a #{type} in the format YYYY-MM-DD."
  end
end
