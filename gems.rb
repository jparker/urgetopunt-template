inject_into_file 'Gemfile', "ruby '#{RUBY_VERSION}'\n", after: /\Asource .*\n/

gem 'asset_sync'
gem 'bootstrap-sass'
gem 'exception_notification'
gem 'haml-rails'
gem 'jquery-ui-rails'
gem 'kaminari'
gem 'newrelic_rpm'
gem 'pry-rails'
gem 'rein'
gem 'simple_form'
gem 'unicorn'

gem_group :development, :test do
  gem 'ffaker'
  gem 'rspec-rails'
end

gem_group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'poltergeist'
  gem 'shoulda-matchers'
  gem 'timecop'
end

gem 'rb-fsevent', group: :darwin, require: false
gem 'rails_12factor', group: [:production, :staging]

gsub_file 'Gemfile', "gem 'turbolinks'\n", ''

run 'bundle install -j 4'
