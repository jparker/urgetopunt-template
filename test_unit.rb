inject_into_file 'test/test_helper.rb', after: "require 'rails/test_help'\n" do
  "\nrequire 'capybara/rails'\n"
end

append_file 'test/test_helper.rb', <<-RUBY

class ActionDispatch::IntegrationTest
  include Capyabara::DSL
end
RUBY
