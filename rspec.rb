generate 'rspec:install'

inject_into_file 'config/application.rb', after: "config.generators do |g|\n" do
  "      g.test_framework :rspec, fixture: false\n"
end

@todo << 'Enable extra config in spec/spec_helper.rb between =begin and =end'

inject_into_file 'spec/rails_helper.rb', after: /^# Add additional requires below this line.*\n/ do
  "require 'shoulda/matchers'\n"
end

inject_into_file 'spec/rails_helper.rb', before: /^end\Z/ do
  <<-RUBY

  # Use a consistent time zone independent of the local time zone. This will
  # make time zone dependencies in tests easier to diagnose rather than
  # sporadically appearing when local time moves to a different time zone. For
  # bonus points, pick a time zone that is a far removed from the local time
  # zone where most development occurs and pick a weird UTC offset if possible.
  #
  # I develop from PDT most of the time. Chatham Is. is UTC+1245.
  config.around :each do |example|
    Time.use_zone 'Chatham Is.', &example
  end

  config.include FactoryGirl::Syntax::Methods
  RUBY
end

inject_into_file 'spec/rails_helper.rb', after: %r{^# Dir\[.*spec/support/.*\].*\n} do
  "\nrequire 'support/database_cleaner'\n"
end

comment_lines 'spec/rails_helper.rb', /config\.use_transactional_fixtures = true/
comment_lines 'spec/rails_helper.rb', /config\.fixture_path/

append_to_file 'spec/rails_helper.rb' do
  <<-RUBY

Spring.after_fork do
  FactoryGirl.reload
end
  RUBY
end

append_to_file '.env', <<-END
SOURCE_ANNOTATION_DIRECTORIES=spec
END

template 'features_helper.rb', 'spec/features_helper.rb'
template 'database_cleaner.rb', 'spec/support/database_cleaner.rb'
template 'have_error_matcher.rb', 'spec/support/have_error_matcher.rb'

Dir.mkdir 'spec/features'

run 'bundle exec guard init'
gsub_file 'Guardfile', /cmd: "bundle exec rspec"/ do
  "cmd: File.join(__dir__, 'bin/rspec')"
end
gsub_file 'Guardfile', 'rspec.spec.("acceptance/#{m[1]}")' do |m|
  'rspec.spec.("features/#{m[1]}")'
end
