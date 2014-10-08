gem 'bootstrap-sass'
gem 'exception_notification'
gem 'font-awesome-sass'
gem 'gctools', require: 'gctools/oobgc'
gem 'haml-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'kaminari-bootstrap'
gem 'newrelic_rpm'
gem 'pry-rails'
gem 'rack-cors', require: 'rack/cors'
gem 'foreigner'
gem 'responders'
# revert to release when bootstrap 3 support is final
gem 'simple_form', github: 'plataformatec/simple_form'
gem 'unicorn'

gem 'spring-commands-rspec', group: :development

gem_group :development, :test do
  gem 'dotenv-rails'
  gem 'ffaker'
  gem 'rspec-rails', '~> 2.99.0.beta2'
end

gem_group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'poltergeist'
  gem 'rspec', '~> 2.99.0.beta2'
  gem 'shoulda-matchers', require: false
  gem 'timecop'
end

gem 'rails_12factor', group: [:production, :staging]

run 'bundle install -j 4'
