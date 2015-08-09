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

DatabaseCleaner.strategy = :transaction

Minitest::Reporters.use! Minitest::Reporters::ProgressReporter.new,
  ENV, Minitest.backtrace_filter

  RUBY
end

inject_into_file 'test/test_helper.rb', after: "# Add more helper methods to be used by all tests here...\n" do
  <<-RUBY

  include FactoryGirl::Syntax::Methods

  def setup
    DatabaseCleaner.start

    # Use a consistent time zone independent of the local time zone. This will
    # make time zone dependencies in tests easier to diagnose rather than
    # sporadically appearing when local time moves to a different time zone. For
    # bonus points, pick a time zone that is a far removed from the local time
    # zone where most development occurs and pick a weird UTC offset if possible.
    #
    # Be sure the currently signed-in user uses the same time zone, e.g., when
    # building the user set the time_zone column to Time.zone to inherit
    # whatever the test is using.
    #
    # I develop from PDT most of the time. Chatham Is. is UTC+1245.
    @_original_time_zone, Time.zone = Time.zone, 'Chatham Is.'
  end

  def teardown
    Time.zone = @_original_time_zone

    DatabaseCleaner.clean
  end

  # This ensure minitest-focus plays nicely with minitest-reporters when
  # ProgressReporter is in use.
  def self.focus
    Minitest::Reporters.use! Minitest::Reporters::SpecReporter.new,
      ENV, Minitest.backtrace_filter
    super
  end
  RUBY
end

run 'bundle exec guard init minitest'
gsub_file 'Guardfile', /guard :minitest/, 'guard :minitest, spring: true'

guardfile = File.readlines('Guardfile').map do |line|
              if line =~ /# Rails 4/ .. line =~ /# Rails < 4/
                line.sub /# (watch.*)/, '\1'
              else
                line
              end
            end
File.write 'Guardfile', guardfile.join

# TODO?: tell spring when to run FactoryGirl.reload
