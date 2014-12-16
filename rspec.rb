generate 'rspec:install'

inject_into_file 'spec/rails_helper.rb', after: /^# Add additional requires below this line.*\n/ do
  "require 'shoulda/matchers'\n"
end

inject_into_file 'spec/rails_helper.rb', before: /^end\Z/ do
  <<-RUBY

  config.filter_run focus: true
  config.run_all_when_everything_filtered = true

  config.order = :random
  Kernel.srand config.seed

  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
  end

  # Use a consistent time zone independent of local machine time zone. This
  # will make time zone brittleness in tests easier to track down.
  config.around :each do |example|
    Time.use_zone 'Kathmandu', &example
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
