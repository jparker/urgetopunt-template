@todo << 'upgrade Gemfile with rails = 4.2.0.rc3 (then run `rake rails:update`)'

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

@todo << 'upgrade Gemfile with responders ~> 2.0 (then run `rails generate responders:install`)'
# gem 'responders', '~> 2.0'
gem 'responders'

gem 'simple_form', '~> 3.1.0'
gem 'unicorn'

gem 'spring-commands-rspec', group: :development

gem_group :development, :test do
  gem 'dotenv-rails'
  gem 'ffaker'
  gem 'rspec-rails', '~> 3.1.0'
end

gem_group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'guard-rspec'
  gem 'launchy'
  gem 'poltergeist'
  gem 'shoulda-matchers', require: false
  gem 'timecop'
end

gem 'rails_12factor', group: [:production, :staging]

run 'bundle install -j 2'
