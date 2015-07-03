generate 'minitest:install'

inject_into_file 'config/application.rb', after: "config.generators do |g|\n" do
  "      g.test_framework :minitest, fixture: false\n"
end

uncomment_lines 'test/test_helper.rb', %r{require ['"]minitest/rails/capybara['"]}
comment_lines 'test/test_helper.rb', %r{fixtures :all}
inject_into_file 'test/test_helper.rb', before: 'class ActiveSupport::TestCase' do
  <<-RUBY

require 'minitest/focus'
require 'minitest/reporters'
require 'shoulda/matchers'

# DefaultReporter provides red-green colorization. Additional reporters could
# be useful when test suite grows large.
#
# Minitest::Reporters.use!
Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new

  RUBY
end

inject_into_file 'test/test_helper.rb', after: "# Add more helper methods to be used by all tests here...\n" do
  <<-RUBY

  include FactoryGirl::Syntax::Methods

  # Use a consistent time zone independent of local machine. This will
  # hopefully make brittle tests with time zone dependencies easier to track
  # down. (For bonus points, use a time zone with an unusual UTC-offset;
  # Kathmandu is UTC+0545.)
  def setup
    @original_time_zone = Time.zone
    Time.zone = 'Kathmandu'
  end

  def teardown
    Time.zone = @original_time_zone
  end
  RUBY
end

# TODO: configure database_cleaner
# TODO: configure guard
# TODO?: include FactoryGirl::Syntax::Methods
# TODO?: tell spring when to run FactoryGirl.reload
