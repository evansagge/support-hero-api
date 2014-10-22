require 'simplecov'
SimpleCov.start

ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'fabrication'
require 'ffaker'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.use_transactional_fixtures = false

  config.infer_spec_type_from_file_location!

  config.before(:suite) do
    DatabaseCleaner.strategy = :deletion
    DatabaseCleaner.clean_with(:truncation)
    Rails.application.routes.default_url_options = { host: ENV['URL_HOST'], protocol: ENV['URL_PROTOCOL'] }
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.include JsonSpec::Helpers
  config.include ActionDispatch::TestProcess

  config.fixture_path = Rails.root.join('spec/fixtures')
end
