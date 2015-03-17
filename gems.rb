gem 'bootstrap-sass'
gem 'exception_notification'
gem 'font-awesome-sass'

RUBY_VERSION.match /\A2\.[01]\./ do
  # only use gctools on ruby < 2.2.0
  gem 'gctools', require: 'gctools/oobgc'
end

gem 'haml-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'kaminari-bootstrap'
gem 'newrelic_rpm'
gem 'pry-rails'
gem 'rack-cors', require: 'rack/cors'
gem 'responders', '~> 2.0'
gem 'simple_form', '~> 3.1.0'

if puma?
  gem 'puma'
  gem 'rack-timeout'
else
  gem 'unicorn'
end

gem_group :development do
  gem 'bundler-audit'
  gem 'spring-commands-rspec' if rspec?
end

gem_group :development, :test do
  gem 'dotenv-rails'
  gem 'ffaker'
  gem 'rspec-rails', '~> 3.1.0' if rspec?
end

gem_group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'guard-rspec' if rspec?
  gem 'launchy'
  gem 'poltergeist'
  gem 'shoulda-matchers', require: false
  gem 'timecop'
end

gem 'rails_12factor', group: [:production, :staging]
