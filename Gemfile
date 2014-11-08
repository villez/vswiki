source 'https://rubygems.org'
ruby '2.1.2'

gem 'rails', '4.1.7'

# Use PostgreSQL both in development & production
gem 'pg', '0.17.1'

# Thin instead of WEBRick in development
gem 'thin'

# the default Rails gems
gem 'sass-rails', '~> 4.0.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails'
gem 'turbolinks'
gem 'jbuilder', '~> 1.2'

# Bootstrap
gem 'bootstrap-sass', '~> 3.2.0'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'spring', '~> 1.1.3'
  gem 'spring-commands-rspec', '~> 1.0.2'
end

group :development, :test do
  gem 'rspec-rails', '~> 3.0.0'
  gem 'capybara', '~> 2.4.4'
  gem 'poltergeist', '~> 1.5.1'
  gem 'launchy', '~> 2.3.0'
  gem 'minitest'
  gem 'shoulda-matchers', '~> 2.5.0'
  gem 'simplecov', require: false
  gem 'database_cleaner', '~> 1.2.0'
  gem 'quiet_assets'
end

# Capistrano for deployment
gem 'capistrano', '~> 3.1.0'
gem 'capistrano-bundler', '~> 1.1.2'
gem 'capistrano-rails', '~> 1.1.1'
gem 'capistrano-rbenv', '~> 2.0'
