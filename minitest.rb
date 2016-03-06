generate 'minitest:install'

inject_into_file 'config/application.rb', after: "config.generators do |g|\n" do
  "      g.test_framework :minitest, fixture: false\n"
end

uncomment_lines 'test/test_helper.rb', %r{require ['"]minitest/rails/capybara['"]}
comment_lines 'test/test_helper.rb', %r{fixtures :all}
inject_into_file 'test/test_helper.rb', before: 'class ActiveSupport::TestCase' do
  <<-RUBY

require 'database_cleaner'
require 'minitest/focus'
require 'minitest/reporters'
require 'shoulda/matchers'

require 'support/error_assertions'
require 'support/flash_assertions'

DatabaseCleaner.strategy = :truncation

Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new,
  ENV, Minitest.backtrace_filter

  RUBY
end

inject_into_file 'test/test_helper.rb', after: "# Add more helper methods to be used by all tests here...\n" do
  <<-RUBY
  self.use_transactional_fixtures = false

  include FactoryGirl::Syntax::Methods

  # This ensure minitest-focus plays nicely with minitest-reporters when
  # ProgressReporter is in use.
  def self.focus
    Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new,
      ENV, Minitest.backtrace_filter
    super
  end

  setup    :prepare_database
  teardown :cleanup_database

  setup    :prepare_time_zone
  teardown :cleanup_time_zone

  def prepare_database
    if !respond_to?(:metadata) || !metadata[:js]
      DatabaseCleaner.strategy = :transaction
      DatabaseCleaner.start
    end
  end

  def cleanup_database
    if respond_to?(:metadata) && metadata[:js]
      DatabaseCleaner.clean_with :deletion
    else
      DatabaseCleaner.clean
    end
  end

  def prepare_time_zone
    # Use a consistent time zone to make time zone dependency issues in tests
    # easier to diagnose.
    @_original_time_zone, Time.zone = Time.zone, 'Chatham Is.'
  end

  def cleanup_time_zone
    Time.zone = @_original_time_zone
  end
  RUBY
end

append_file 'test/test_helper.rb', <<-RUBY

class Capybara::Rails::TestCase
  include ErrorAssertions
  include FlashAssertions
end
RUBY

template 'error_assertions.rb', 'test/support/error_assertions.rb'
template 'flash_assertions.rb', 'test/support/flash_assertions.rb'

run 'bundle exec guard init minitest'
gsub_file 'Guardfile', /guard :minitest/, 'guard :minitest, spring: true'
gsub_file 'Guardfile', %r{test/integration}, 'test/features'

guardfile = File.readlines('Guardfile').map do |line|
              if line =~ /# Rails 4/ .. line =~ /# Rails < 4/
                line.sub /# (watch.*)/, '\1'
              else
                line
              end
            end
File.write 'Guardfile', guardfile.join

create_file 'test/factories/.gitkeep'

# TODO?: tell spring when to run FactoryGirl.reload
