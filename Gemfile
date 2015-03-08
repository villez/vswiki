source 'https://rubygems.org'
ruby '2.2.0'

gem 'rails', '4.2.0'

# Use PostgreSQL both in development & production
gem 'pg', '0.18.1'

# Thin instead of WEBRick in development
gem 'thin'

# the default Rails gems
gem 'sass-rails', '~> 5.0.1'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 2.0'

# Bootstrap
gem 'bootstrap-sass', '~> 3.3.3'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0', require: false
end

group :development do
  gem 'spring', '~> 1.3.2'
  gem 'spring-commands-rspec', '~> 1.0.2'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.2.1'
  gem 'capybara', '~> 2.4.4'
  gem 'poltergeist', '~> 1.6.0'
  gem 'launchy', '~> 2.4.3', require: false
  gem 'shoulda-matchers', '~> 2.8.0', require: false
  gem 'simplecov', '~> 0.9.1', require: false
  gem 'database_cleaner', '~> 1.4.0'
  gem 'quiet_assets', '~> 1.1.0'
end

# Capistrano for deployment
gem 'capistrano', '~> 3.4.0'
gem 'capistrano-bundler', '~> 1.1.2'
gem 'capistrano-rails', '~> 1.1.1'
gem 'capistrano-rbenv', '~> 2.0'
