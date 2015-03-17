# set ruby version
inject_into_file 'Gemfile', "ruby '#{RUBY_VERSION}'\n", after: /\Asource .*\n/
create_file '.ruby-version', "#{RUBY_VERSION}\n"

# housekeeping that must be performed before anything below
create_file '.env'
create_file 'Procfile'

append_file '.env', "SENSIBLE_DEFAULTS=true\n"

# maintain database schema in sql format to support triggers, etc.
application "config.active_record.schema_format = :sql\n"
