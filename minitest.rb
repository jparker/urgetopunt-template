inject_into_file 'test/test_helper.rb', <<-RUBY, after: "require 'rails/test_help'\n"

require 'capybara/rails'
require 'minitest/focus'
require 'minitest/reporters'
require 'shoulda/matchers'

# DefaultReporter provides red-green colorization. Additional reporters could
# be useful when test suite grows large.
#
# Minitest::Reporters.use!
Minitest::Reporters.use! Minitest::Reporters::DefaultReporter.new
RUBY

append_file 'test/test_helper.rb', <<-RUBY

class ActionDispatch::IntegrationTest
  include Capyabara::DSL
end
RUBY

# TODO: set fixed time zone for tests (Kathmandu)
# TODO: configure database_cleaner
# TODO: configure guard
# TODO?: include FactoryGirl::Syntax::Methods
# TODO?: tell spring when to run FactoryGirl.reload
