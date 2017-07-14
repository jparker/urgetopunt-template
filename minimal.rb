# Usage:
#
# rails new APP_NAME -m minimal.rb

application "config.active_record.schema_format = :sql\n"
create_file 'Procfile', "web: rails server\n"

comment_lines 'Gemfile', /gem 'tzinfo-data'/

gem 'awesome_print'
gem 'pry-rails'
create_file '.pryrc', "AwesomePrint.pry!\n"

inject_into_file 'config/database.yml',
  after: /database: #{app_name}_(development|test)\n/, force: true do
  <<-YAML
  username: #{`whoami`}
  YAML
end

gem 'bootstrap-sass'
gem 'jquery-rails'
copy_file 'app/assets/stylesheets/application.css',
  'app/assets/stylesheets/application.css.scss'
remove_file 'app/assets/stylesheets/application.css'
append_file 'app/assets/stylesheets/application.css.scss', <<-SCSS

@import 'bootstrap-sprockets';
@import 'bootstrap';

body {
  margin-top: 60px;
}
SCSS

inject_into_file 'app/assets/javascripts/application.js',
  <<-JS, before: %r{//= require_tree}
//= require jquery
//= require bootstrap
JS

gem 'hamlit-rails'
remove_file 'app/views/layouts/application.html.erb'
create_file 'app/views/layouts/application.html.haml', <<-HAML
!!! 5
%html(lang='en')
  %head
    %title #{app_name}
    %meta(charset='utf-8')
    %meta(name='viewport' content='width=device-width, initial-scale=1')
    %meta(http-equiv='X-UA-Compatible' content='IE=edge')
    = csrf_meta_tags
    = stylesheet_link_tag 'application', media: 'all', 'data-turbolinks-track': 'reload'
    = javascript_include_tag 'application', 'data-turbolinks-track': 'reload'
  %body
    .container
      - if flash[:alert]
        .alert.alert-danger
          %span.glyphicon.glyphicon-alert
          = flash[:alert]

      - if flash[:notice]
        .alert.alert-success
          %span.glyphicon.glyphicon-check
          = flash[:notice]

      - if flash[:info]
        .alert.alert-info
          %span.glyphicon.glyphicon-info-sign
          = flash[:info]

      = yield
HAML

after_bundle do
  git add: '-A'
end
