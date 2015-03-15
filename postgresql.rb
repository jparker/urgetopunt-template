# install migration to create citext extension
template 'create_citext_extension.rb',
  'db/migrate/001_create_citext_extension.rb'

# maintain database schema in sql format to support triggers, etc.
application "config.active_record.schema_format = :sql\n"
