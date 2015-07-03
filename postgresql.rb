# install migration to create citext extension
template 'enable_citext.rb', 'db/migrate/001_enable_citext.rb'

# maintain database schema in sql format to support triggers, etc.
application "config.active_record.schema_format = :sql\n"
