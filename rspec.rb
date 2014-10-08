generate 'rspec:install'

inject_into_file 'spec/rails_helper.rb',
  "require 'capybara/poltergeist'\n",
  after: "require 'rspec/rails'\n"
inject_into_file 'spec/rails_helper.rb',
  "require 'capybara/rails'\n",
  after: "require 'rspec/rails'\n"
inject_into_file 'spec/rails_helper.rb',
  "require 'shoulda/matchers'\n",
  after: "require 'rspec/rails'\n"

inject_into_file 'spec/rails_helper.rb',
  "Spring.after_fork do\n  FactoryGirl.reload\nend\n",
  after: "Migration.maintain_test_schema!\n"
inject_into_file 'spec/rails_helper.rb',
  "Capybara.javascript_driver = :poltergeist\n",
  after: "Migration.maintain_test_schema!\n"

inject_into_file 'spec/rails_helper.rb',
  "  config.filter_run focus: true\n",
  before: /^end\Z/
inject_into_file 'spec/rails_helper.rb',
  "  config.run_all_when_everything_filtered = true\n",
  before: /^end\Z/
inject_into_file 'spec/rails_helper.rb',
  "  config.order = :random\n  Kernel.srand config.seed\n",
  before: /^end\Z/
inject_into_file 'spec/rails_helper.rb',
  "  config.mock_with :rspec do |mocks|\n    mocks.syntax = :expect\n  end\n",
  before: /^end\Z/

inject_into_file 'spec/rails_helper.rb',
  "  # make time zone brittleness easy to detect\n  config.around :each do |example|\n    Time.use_zone 'Kathmandu', &example\n  end\n",
  before: /^end\Z/

inject_into_file 'spec/rails_helper.rb',
  "  config.include FactoryGirl::Syntax::Methods\n",
  before: /^end\Z/

# configure database_cleaner
template 'database_cleaner.rb', 'spec/support/database_cleaner.rb'

gsub_file 'spec/rails_helper.rb',
  'config.use_transactional_fixtures = true',
  "# see spec/support/database_cleaner.rb\n  config.use_transactional_fixtures = false"

run 'bundle exec guard init'
gsub_file 'Guardfile', 'guard :rspec do', "guard :rspec, cmd: './bin/rspec' do"
