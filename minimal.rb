# rails new APP_NAME --skip-bundle --no-skip-test-unit

apply File.join __dir__, 'base_pre.rb'

gem 'awesome_print'
gem 'pry-rails'

create_file '.pryrc', "AwesomePrint.pry!\n"

# install gems
bundle_opts = ENV.fetch('BUNDLE_OPTS') { '-j2' }
run "bundle install #{bundle_opts}"

append_file 'Procfile', "web: rails server\n"

apply File.join __dir__, 'base_post.rb'
