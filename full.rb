# Usage:
#
# rails new APP_NAME --skip-test --skip-system-test -d postgresql -m full.rb
#
# This template adds several gems and calls generators that may depend on these
# gems. It assumes you will use RSpec for testing and PostgreSQL as your data
# store. Therefore, you should pass the following options to `rails new`:
#
# --skip-test
# --skip-system-test
# --database=postgreql

def source_paths
  [File.join(__dir__, 'templates'), *super]
end

#
# Preprocessing
#
application "config.active_record.schema_format = :sql\n"
create_file 'Procfile', "web: rails server\n"
application <<-RUBY
config.generators do |g|
      g.assets false
      g.helper false
    end
RUBY

inject_into_file 'Gemfile', "ruby '~> #{RUBY_VERSION}'\n", after: /^source '.*'\n/
create_file '.ruby-version', "#{RUBY_VERSION}\n"

comment_lines 'Gemfile', /gem 'tzinfo-data'/
gem 'newrelic_rpm'
gem 'rails_12factor', group: :production

# There is a bug in Rails which can cause generators executed within an
# after_bundle block to hang. The bug is documented in this Github issue:
#
# https://github.com/rails/rails/issues/21700
#
# A workaround is to stop spring after install the gems and before running any
# generators. This approach requires the spring gem to be installed globally
# alonside the rails gem.
after_bundle do
  run 'spring stop'
end

%w[ development test ].each do |env|
  uncomment_lines "config/environments/#{env}.rb",
    /config\.action_view\.raise_on_missing_translations = true/
end

uncomment_lines 'config/environments/production.rb', /config\.force_ssl = true/

#
# Dotenv
#
# This section creates the .env files which will be used below.
#
gem 'dotenv-rails', group: [:development, :test]

create_file '.env'
create_file '.env.development'
create_file '.env.test'
append_file '.gitignore', ".env*\n"

after_bundle do
  %w[ development test ].each do |env|
    append_file ".env.#{env}", "HEROKU_APP_NAME=#{app_name}-#{env}\n"
    prepend_file "config/environments/#{env}.rb",
      "Dotenv.load Rails.root.join '.env.#{env}'\n"
  end
end

#
# RSpec
#
# Installing RSpec will alter the way some generators behave, so make sure its
# after_bundle block is called before any others.
#
gem_group :development, :test do
  gem 'faker'
  gem 'rspec-rails'
end

gem_group :development do
  gem 'spring-commands-rspec'
end

gem_group :test do
  gem 'capybara-webkit'
  gem 'database_cleaner'
  gem 'factory_girl_rails'
  gem 'shoulda-matchers'
end

append_file '.env', "SOURCE_ANNOTATION_DIRECTORIES=spec\n"
append_file '.gitignore', "spec/examples.txt\n"
create_file 'spec/factories/.gitkeep'

template 'database_cleaner.rb', 'spec/support/database_cleaner.rb'
template 'have_error_matcher.rb', 'spec/support/have_error_matcher.rb'
template 'have_flash_matcher.rb', 'spec/support/have_flash_matcher.rb'

after_bundle do
  generate 'rspec:install'

  inject_into_file 'config/application.rb', <<-RUBY, after: /g\.helper = false/
      g.test_framework :rspec, fixture: false
  RUBY

  gsub_file 'spec/spec_helper.rb', /^=begin/, ''
  gsub_file 'spec/spec_helper.rb', /^=end/, ''

  uncomment_lines 'spec/rails_helper.rb',
    Regexp.escape("Dir[Rails.root.join('spec/support/**/*.rb')]")
  comment_lines 'spec/rails_helper.rb', /config\.use_transactional_fixtures = true/
  comment_lines 'spec/rails_helper.rb', /config\.fixture_path/

  inject_into_file 'spec/rails_helper.rb', <<-RUBY, after: /^# Add additional requires.*\n/

  require 'capybara/rails'
  RUBY

  inject_into_file 'spec/rails_helper.rb', <<-RUBY, after: /maintain_test_schema!\n/

  Capybara.javascript_driver = :webkit

  Capybara::Webkit.configure do |config|
    config.block_unknown_urls
  end

  Shoulda::Matchers.configure do |config|
    config.integrate do |with|
      with.test_framework :rspec
      with.library :rails
    end
  end
  RUBY

  inject_into_file 'spec/rails_helper.rb', <<-RUBY, before: /^end\Z/

    # Make time zone dependencies in tests easier to expose.
    config.around :each do |example|
      Time.use_zone 'Chatham Is.', &example
    end

    config.include ActiveSupport::Testing::TimeHelpers
    config.include FactoryGirl::Syntax::Methods
  RUBY
end

#
# Cloudfront
#
gem 'rack-cors', require: 'rack/cors'

comment_lines 'config/environments/production.rb',
  /config\.serve_static_assets = false/

gsub_file 'config/environments/production.rb',
  "'http://assets.example.com'", "ENV['CLOUDFRONT_URL']"

environment <<-RUBY, env: 'production'
config.middleware.insert_before ActionDispatch::Static, Rack::Cors do
    allow do
      origins "https://\#{ENV['PUBLIC_SERVER_NAME']}"
      resource '/assets/*', headers: :any, methods: [:get, :head]
    end
  end

  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=\#{1.month.to_i}",
  }
RUBY

#
# Console
#
gem 'awesome_print'
gem 'pry-rails'
template 'pryrc', '.pryrc'

#
# Docker dependencies
#
inject_into_file 'config/database.yml',
  after: /database: #{app_name}_(development|test)\n/, force: true do
  <<-YAML
  host: localhost
  port: 32768
  username: #{app_name}
  password: awooga
  YAML
end

gsub_file 'config/database.yml', /^production:\n.*\n.*\n.*\n.*\n/ do
  <<~YAML
production:
  url: <%= ENV['DATABASE_URL'] %>
  YAML
end

append_file '.env', "PGPASSWORD=awooga\n"

template 'docker-init', 'bin/docker-init'
template 'docker-up',   'bin/docker-up'
template 'docker-down', 'bin/docker-down'

chmod 'bin/docker-init', 0755
chmod 'bin/docker-up',   0755
chmod 'bin/docker-down', 0755

#
# Exception handling
#
gem 'exception_notification'
route "get 'exceptions/test' => 'exceptions#test'"

after_bundle do
  generate 'exception_notification:install'
  generate 'controller', 'exceptions'

  inject_into_file 'app/controllers/exceptions_controller.rb', before: /end/ do
    <<-RUBY
    def test
      raise 'This action deliberately raises a RuntimeError' \\
        ' in order to test exception notification.'
    end
    RUBY
  end

  inject_into_file 'spec/controllers/exceptions_controller_spec.rb', before: /end/ do
    <<-RUBY
    it { expect { get :test }.to raise_error RuntimeError }
    RUBY
  end
end

#
# Logging
#
%w[ development test ].each do |env|
  environment <<-RUBY, env: env
# Rotate logs when they exceed 5MB; keep three most recent.
  config.logger = ActiveSupport::Logger.new \\
    Rails.root.join('log', Rails.env + '.log'), 5, 5 * 1_000_000
  RUBY
end

#
# Mailer configuration
#
environment <<-RUBY, env: 'development'
config.action_mailer.default_url_options = {
    host: 'localhost',
    port: ENV['PORT'] || 5000,
  }
RUBY

environment <<-RUBY, env: 'test'
config.action_mailer.default_url_options = {
    host: 'test.host',
  }
RUBY

environment <<-RUBY, env: 'production'
config.action_mailer.default_url_options = {
    protocol: 'https',
    host: ENV['PUBLIC_SERVER_NAME'],
  }

  config.action_mailer.delivery_method = :smtp

  config.action_mailer.smtp_settings = {
    address:              'smtp.sendgrid.net',
    port:                 '587',
    authentication:       :plain,
    user_name:            ENV['SENDGRID_USERNAME'],
    password:             ENV['SENDGRID_PASSWORD'],
    domain:               'heroku.com',
    enable_starttls_auto: true,
  }
RUBY

#
# Error and maintenance pages
#
gem 'aws-sdk'

remove_file 'public/404.html'
remove_file 'public/422.html'
remove_file 'public/500.html'

template '404.html', 'public/404.html'
template '422.html', 'public/422.html'
template 'error.html', 'public/error.html'
template 'maintenance.html', 'public/maintenance.html'

create_link 'public/500.html', 'error.html'

rakefile 'pages.rake' do
  <<~RUBY
    desc 'Upload error and maintenance pages to S3'
    task :pages, %i[bucket] => %i[pages:error pages:maintenance]

    namespace :pages do
      desc 'Upload error.html to S3'
      task :error, %i[bucket] => :environment do |t, args|
        args.with_defaults bucket: ENV['AWS_BUCKET']
        file = 'error.html'
        uploader = Aws::S3::FileUploader.new
        uploader.upload File.open(Rails.root.join('public', file)),
          bucket: args[:bucket], key: file, acl: 'public-read'
      end

      desc 'Upload maintenance.html to S3'
      task :maintenance, %i[bucket] => :environment do |t, args|
        args.with_defaults bucket: ENV['AWS_BUCKET']
        file = 'maintenance.html'
        uploader = Aws::S3::FileUploader.new
        uploader.upload File.open(Rails.root.join('public', file)),
          bucket: args[:bucket], key: file, acl: 'public-read'
      end
    end
  RUBY
end

#
# PostgreSQL configuration
#
after_bundle do
  %w[ citext plpgsql pg_trgm ].each do |ext|
    generate "migration", "enable_#{ext}_extension"
    in_root do
      file = Dir["db/migrate/*_enable_#{ext}_extension.rb"].first
      inject_into_file file, "    enable_extension '#{ext}'\n", before: /^  end/
    end
  end
end

#
# Responders
#
gem 'responders'

after_bundle do
  generate 'responders:install'
end

#
# Views
#
gem 'bootstrap-sass'
gem 'jquery-rails'
copy_file 'app/assets/stylesheets/application.css',
  'app/assets/stylesheets/application.css.scss'
remove_file 'app/assets/stylesheets/application.css'
append_file 'app/assets/stylesheets/application.css.scss', <<-SCSS

@import 'bootstrap-sprockets';
@import 'bootstrap';
@import 'bootstrap/theme';

body {
  margin-top: 60px;
}
SCSS

inject_into_file 'app/assets/javascripts/application.js',
  <<-JS, before: %r{//= require_tree}
//= require jquery
//= require bootstrap
JS

gem 'jquery-ui-rails'

gem 'font-awesome-sass'
inject_into_file 'app/assets/stylesheets/application.css.scss',
  <<-SCSS, after: /\*\//

@import 'font-awesome-sprockets';
@import 'font-awesome';
SCSS

gem 'hamlit-rails'
remove_file 'app/views/layouts/application.html.erb'
template 'application.haml', 'app/views/layouts/application.html.haml'
template 'flash_helper.rb', 'app/helpers/flash_helper.rb'
template 'flash.haml', 'app/views/application/_flash.haml'
template 'alert.haml', 'app/views/application/_alert.haml'

gem 'simple_form'
after_bundle do
  generate 'simple_form:install', '--bootstrap'
end

gem 'kaminari'
after_bundle do
  generate 'kaminari:config'
  generate 'kaminari:views', 'bootstrap3'
end

#
# Postprocessing
#
remove_file 'README.md'
create_file 'README.md', <<-TXT
Before deploying this application, you may need to setup environment variables:

* SENSIBLE_DEFAULTS=true
* RAILS_MAX_THREADS=5
* RAILS_SERVE_STATIC_FILES=true
* SECRET_KEY_BASE=`rails secret`
* AWS_ACCESS_KEY
* AWS_SECRET_ACCESS_KEY
* AWS_BUCKET
* AWS_REGION
* ERROR_PAGE_URL
* MAINTENANCE_PAGE_URL
* PUBLIC_SERVER_NAME
* CLOUDFRONT_URL
TXT

# Generate migrations to enable citext, plpgsql, pg_trgm extensions.

after_bundle do
  git add: '-A'
end
