# rails new APP_NAME --skip-bundle --no-skip-test-unit

inject_into_file 'Gemfile', "ruby '#{RUBY_VERSION}'\n", after: /\Asource .*\n/

gem 'pry-rails'

# maintain database schema in sql format to support triggers, etc.
application "config.active_record.schema_format = :sql\n"

bundle_opts = ENV.fetch('BUNDLE_OPTS') { '-j2' }
run "bundle install #{bundle_opts}"
run 'bundle exec spring binstub --all'

git :init
git add: '-A'
git commit: '-m "initial commit"'
