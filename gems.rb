gem 'bootstrap-sass'
gem 'exception_notification'
gem 'font-awesome-sass'

gem 'awesome_print'
gem 'aws-sdk'
gem 'hamlit-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'kaminari-bootstrap'
gem 'newrelic_rpm'
gem 'pry-rails'
gem 'puma'
gem 'rack-cors', require: 'rack/cors'
gem 'rack-timeout'
gem 'responders'
gem 'sass-rails'
gem 'simple_form'

gem_group :development do
  gem 'bundler-audit'
  gem 'spring-commands-rspec' if rspec?
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
  gem 'shoulda-matchers'
end

gem 'rails_12factor', group: [:production]
