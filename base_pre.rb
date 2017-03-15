# set ruby version
inject_into_file 'Gemfile', "ruby '#{RUBY_VERSION}'\n", after: /\Asource .*\n/
create_file '.ruby-version', "#{RUBY_VERSION}\n"

create_file '.env', "SENSIBLE_DEFAULTS=true\n"
create_file '.env.development', "HEROKU_APP_NAME=#{@app_name}-development\n"
create_file '.env.test', "HEROKU_APP_NAME=#{@app_name}-test\n"
create_file 'Procfile'

# maintain database schema in sql format to support triggers, etc.
application "config.active_record.schema_format = :sql\n"
