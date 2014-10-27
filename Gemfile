source 'https://rubygems.org'

gem 'rails', '~> 4.1'
gem 'rails-api', '~> 0.3'
gem 'pg', '~> 0.17'
gem 'bcrypt', '~> 3.1.7'
gem 'doorkeeper'
gem 'pundit'
gem 'unicorn'

gem 'acts_as_list'
gem 'active_model_serializers', github: 'rails-api/active_model_serializers', branch: '0-9-stable'
gem 'rack-cors', require: 'rack/cors'
gem 'responders'

gem 'holidays', github: 'evansagge/holidays'
gem 'chronic'
gem 'business_time'

gem 'thor'
gem 'thor-rails'

gem 'newrelic_rpm'

group :development do
  gem 'annotate'
  gem 'capistrano'
  gem 'dotenv-rails'
  gem 'hirb'
  gem 'pry-byebug'
  # gem 'pry-nav'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'spring'
  gem 'thin'
end

group :development, :test do
  gem 'ffaker'
  gem 'rubocop'
  gem 'guard'
  gem 'guard-rubocop'
  gem 'guard-rspec'
end

group :test do
  gem 'database_cleaner', '~> 1.3'
  gem 'fabrication', '~> 2.11'
  gem 'rspec-rails', '~> 3.1'
  gem 'spring-commands-rspec'
  gem 'json_spec'
  gem 'simplecov', require: false
  gem 'oauth2'
end
