source 'https://rubygems.org'

gem 'rails', '~> 4.1'
gem 'rails-api', '~> 0.3'
gem 'pg', '~> 0.17'
gem 'unicorn'

gem 'active_model_serializers', github: 'rails-api/active_model_serializers', branch: '0-9-stable'
gem 'rack-cors', require: 'rack/cors'
gem 'responders'

gem 'holidays', github: 'evansagge/holidays'
gem 'chronic'
gem 'business_time'

group :development do
  gem 'annotate'
  gem 'capistrano'
  gem 'pry-byebug'
  gem 'pry-nav'
  gem 'pry-rails'
  gem 'pry-remote'
  gem 'pry-stack_explorer'
  gem 'spring'
  gem 'thin'
end

group :development, :test do
  gem 'ffaker'
  gem 'rubocop'
end

group :test do
  gem 'database_cleaner', '~> 1.3'
  gem 'fabrication', '~> 2.11'
  gem 'rspec-rails', '~> 3.1'
  gem 'spring-commands-rspec'
end

