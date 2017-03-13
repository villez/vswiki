source 'https://rubygems.org'
ruby '2.4.0'

gem 'rails', '5.0.1'

# Use PostgreSQL both in development & production
gem 'pg', '0.19.0'

# Thin instead of WEBRick in development
gem 'thin'

# the default Rails gems
gem 'sass-rails'
gem 'uglifier', '>= 1.3.0'
gem 'jquery-rails'
gem 'turbolinks', "~> 5.0.0"

# Bootstrap
gem 'bootstrap-sass', '~> 3.3.4'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', '~> 0.4.0', require: false
end

group :development do
  gem 'spring', '~> 2.0.0'
  gem 'spring-commands-rspec', '~> 1.0.2'
end

group :development, :test do
  gem 'rails-controller-testing'
  gem 'rspec-rails', '~> 3.5'
  gem 'capybara', '~> 2.9.2'
  gem 'poltergeist', '~> 1.10.0'
  gem 'launchy', '~> 2.4.3', require: false
  gem 'shoulda-matchers', '~> 2.8.0', require: false
  gem 'simplecov', '~> 0.10.0', require: false
  gem 'database_cleaner', '~> 1.5.3'
end

# Capistrano for deployment
gem 'capistrano', '~> 3.4.0'
gem 'capistrano-bundler', '~> 1.1.4'
gem 'capistrano-rails', '~> 1.1.3'
gem 'capistrano-rbenv', '~> 2.0'
