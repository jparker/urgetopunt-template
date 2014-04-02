gem 'bootstrap-sass'
gem 'exception_notification'
gem 'gctools', require: 'gctools/oobgc'
gem 'haml-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'kaminari-bootstrap'
gem 'newrelic_rpm'
gem 'pry-rails'
gem 'rack-cors', require: 'rack/cors'
gem 'rein'
gem 'simple_form'
gem 'unicorn'

gem 'spring-commands-rspec', group: :development

gem_group :development, :test do
  gem 'ffaker'
  gem 'rspec-rails', '~> 3.0.0.beta2'
end

gem_group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'poltergeist'
  gem 'shoulda-matchers', require: false
  gem 'timecop'
end

gem 'rails_12factor', group: [:production, :staging]

run 'bundle install -j 4'
