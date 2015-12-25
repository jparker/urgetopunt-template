gem 'bootstrap-sass'
gem 'exception_notification'
gem 'font-awesome-sass'

# only use gctools on ruby < 2.2.0
if RUBY_VERSION.match /\A2\.[01]\./
  gem 'gctools', require: 'gctools/oobgc'
end

gem 'haml-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'kaminari-bootstrap'
gem 'newrelic_rpm'
gem 'pry-rails'
gem 'rack-cors', require: 'rack/cors'
gem 'responders'
gem 'sass-rails'
gem 'simple_form'

if puma?
  gem 'puma'
  gem 'rack-timeout'
else
  gem 'unicorn'
end

gem_group :development do
  gem 'bundler-audit'
  gem 'spring-commands-rspec' if rspec?
  gem 'quiet_assets'
end

gem_group :development, :test do
  gem 'dotenv-rails'
  gem 'faker'
  gem 'rspec-rails' if rspec?
end

gem_group :test do
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'factory_girl_rails'

  if rspec?
    gem 'guard'
    gem 'guard-rspec'
  else
    gem 'guard'
    gem 'guard-minitest'
    gem 'minitest-focus'
    gem 'minitest-rails'
    gem 'minitest-rails-capybara'
    gem 'minitest-reporters'
  end

  gem 'launchy'
  gem 'shoulda-matchers', require: false
  gem 'timecop'
end

gem 'rails_12factor', group: [:production, :staging]
