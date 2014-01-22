# rails new NAME --skip-bundle --skip-test-unit

def source_paths
  [File.join(File.dirname(__FILE__), 'templates'), *super]
end

apply File.join(File.dirname(__FILE__), 'gems.rb')

inject_into_file 'config/application.rb', <<-RUBY, after: 'Bundler.require(:default, Rails.env)'

# inserted by urgetopunt-template
Bundler.require(:darwin) if RUBY_PLATFORM.match(/darwin/i)
RUBY

application <<-RUBY
    # inserted by urgetopunt-template
    config.generators do |g|
      g.helper false
      g.assets false
      g.test_framework :rspec, fixture: false
    end

    config.active_record.schema_format = :sql
RUBY

%w[development test].each do |env|
  environment <<-RUBY, env: env
  # log rotation
  config.logger = Logger.new(Rails.root.join('log', Rails.env + '.log'), 5, 5 * 1024 * 1024)
  RUBY
end

remove_file 'app/views/layouts/application.html.erb'
template 'application.html.haml', 'app/views/layouts/application.html.haml'
template 'flash.html.haml', 'app/views/application/_flash.html.haml'
template 'flash_helper.rb', 'app/helpers/flash_helper.rb'
template 'unicorn.rb', 'config/unicorn.rb'

# I can't figure out the correct #copy_file incantation here
in_root { FileUtils.cp 'config/database.yml', 'config/database.yml.example' }

copy_file 'app/assets/stylesheets/application.css', 'app/assets/stylesheets/application.css.scss'
remove_file 'app/assets/stylesheets/application.css'
append_file 'app/assets/stylesheets/application.css.scss', <<-SCSS
@import 'bootstrap';
body {
  margin-top: 60px;
}
SCSS

gsub_file 'app/assets/javascripts/application.js', "//= require turbolinks\n", ''
inject_into_file 'app/assets/javascripts/application.js', "\n//= require bootstrap", after: 'require jquery_ujs'

generate 'rspec:install'
generate 'kaminari:config'
generate 'kaminari:views', 'bootstrap'
generate 'simple_form:install', '--bootstrap'

remove_file 'spec/spec_helper.rb'
template 'spec_helper.rb', 'spec/spec_helper.rb'
template 'database_cleaner.rb', 'spec/support/database_cleaner.rb'
create_file 'spec/factories/.keep'

remove_file 'README.rdoc'
create_file 'README', <<-END
To get asset_sync working on Heroku, set asset_host in production.rb, and run
the following heroku command:

$ heroku labs:enable user-env-compile -a NAME_OF_HEROKU_APP
$ heroku config:set AWS_ACCESS_KEY_ID=XXX AWS_SECRET_ACCESS_KEY=YYY FOG_DIRECTORY=ZZZ FOG_PROVIDER=AWS
END


append_file '.gitignore', <<GITIGNORE
config/database.yml
GITIGNORE

git :init
git add:    '.'
git commit: '-m "initial commit"'
