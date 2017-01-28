generate 'rspec:install'

inject_into_file 'config/application.rb', after: "config.generators do |g|\n" do
  "      g.test_framework :rspec, fixture: false\n"
end

@todo << 'Enable extra config in spec/spec_helper.rb between =begin and =end'

inject_into_file 'spec/rails_helper.rb', after: /^# Add additional requires below this line.*\n/ do
  <<-RUBY
require 'capybara/rails'
  RUBY
end

inject_into_file 'spec/rails_helper.rb', after: /maintain_test_schema!\n/ do
  <<-RUBY
Capybara.javascript_driver = :webkit
Capybara::Webkit.configure do |config|
  config.block_unknown_urls
end

Shoulda::Matchers.configure do |config|
  config.integrate do |with|
    with.test_framework :rspec
    with.library :rails
  end
end
  RUBY
end

inject_into_file 'spec/rails_helper.rb', before: /^end\Z/ do
  <<-RUBY

  config.around :each do |example|
    Time.use_zone 'Chatham Is.', &example
  end

  config.include ActiveSupport::Testing::TimeHelpers
  config.include FactoryGirl::Syntax::Methods
  RUBY
end

uncomment_lines 'spec/rails_helper.rb',
  Regexp.escape("Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }")
comment_lines 'spec/rails_helper.rb', /config\.use_transactional_fixtures = true/
comment_lines 'spec/rails_helper.rb', /config\.fixture_path/

append_to_file '.env', <<-END
SOURCE_ANNOTATION_DIRECTORIES=spec
END

template 'features_helper.rb', 'spec/features_helper.rb'
template 'database_cleaner.rb', 'spec/support/database_cleaner.rb'
template 'have_error_matcher.rb', 'spec/support/have_error_matcher.rb'
template 'have_flash_matcher.rb', 'spec/support/have_flash_matcher.rb'

create_file 'spec/factories/.gitkeep'

Dir.mkdir 'spec/features'

run 'bundle exec guard init'
gsub_file 'Guardfile', '"acceptance/#{m[1]}"', '"features/#{m[1]}"'

append_to_file '.gitignore', "spec/examples.text\n"
