# Use this file to load modules and perform configuration that should only
# affect feature specs.

require 'rails_helper'

require 'capybara/rails'
require 'capybara/poltergeist'

require 'support/have_error_matcher'

Capybara.javascript_driver = :poltergeist

RSpec.configure do |config|
  # For example:
  # config.include Authentication, type: :feature
end
