# rails new APP_NAME --skip-bundle --no-skip-test-unit

# set ruby version
inject_into_file 'Gemfile', "ruby '#{RUBY_VERSION}'\n", after: /\Asource .*\n/
create_file '.ruby-version', "#{RUBY_VERSION}\n"

# i love pry
gem 'pry-rails'

# maintain database schema in sql format to support triggers, etc.
application "config.active_record.schema_format = :sql\n"

# install gems
bundle_opts = ENV.fetch('BUNDLE_OPTS') { '-j2' }
run "bundle install #{bundle_opts}"
run 'bundle exec spring binstub --all'

# initialize git
git :init
git add: '-A'
git commit: '-m "initial commit"'
