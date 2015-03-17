# Minimal template

To generate a Rails application with minimal features from this template:

  $ rails new APP_NAME -m \
  > https://github.com/jparker/urgetopunt-template/minimal.rb --skip-bundle

# Full template

To generate a Rails application with the full set of features:

  $ rails new APP_NAME -m \
  > https://github.com/jparker/urgetopunt-template/full.rb --skip-bundle \
  > -d postgresql

The full template includes some PostgreSQL-specific features, so be sure to
include the -d option above.

The full template also gives you the option of generating RSpec configuration.
If you are using RSpec, you should pass the --skip-test-unit option to disable
Rails' test-unit configuration.

# Miscellaneous options

To disable turbolinks, pass the --skip-turbolinks option.

Regardless of which feature set you use, you should pass the --skip-bundle
option when generating the application. Both templates run `bundle install`
early on after specifying gems in order to make sure bundled gems are available
when running any additional generators.

The BUNDLE\_OPTS environment variable can be used to pass arguments to
`bundle install`, e.g., BUNDLE\_OPTS="-j2".
