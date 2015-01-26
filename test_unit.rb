append_file 'test/test_helper.rb', <<-RUBY

Capybara.app, _ = Rack::Builder.parse_file File.expand_path Rails.root.join 'config.ru'

class ActionDispatch::IntegrationTest
  include Capyabara::DSL
end
RUBY
