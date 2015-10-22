# Use this file to load modules and perform configuration that should only
# affect feature specs.

require 'rails_helper'

require 'capybara/rails'

require 'support/have_error_matcher'

Capybara.javascript_driver = :webkit
Capybara.configure do |config|
  config.block_unknown_urls
end

RSpec.configure do |config|
  # For example:
  # config.include Authentication, type: :feature
end
