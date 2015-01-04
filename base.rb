# rails new APP_NAME --skip-bundle --skip-test-unit [--skip-turbolinks] [-d postgresql]

@todo = []

def source_paths
  [File.join(__dir__, 'templates'), *super]
end

# set ruby version
inject_into_file 'Gemfile', "ruby '#{RUBY_VERSION}'\n", after: /\Asource .*\n/

# housekeeping that must be performed before anything below
create_file '.env'

apply File.join(__dir__, 'gems.rb')
apply File.join(__dir__, 'general.rb')
apply File.join(__dir__, 'cloudfront.rb')
apply File.join(__dir__, 'sendgrid.rb')
apply File.join(__dir__, 'unicorn.rb')
apply File.join(__dir__, 'views.rb')
apply File.join(__dir__, 'memory.rb')
apply File.join(__dir__, 'rspec.rb')
apply File.join(__dir__, 'exceptions.rb')
apply File.join(__dir__, 'responders.rb')
apply File.join(__dir__, 'postgresql.rb')

# Should be applied after all other changes to config/environments/production.rb
apply File.join(__dir__, 'staging.rb')

# spring-ify commands
run 'bundle exec spring binstub --all'

@todo << "Setup git remotes: 'git remote add origin git@github.com:...'"

File.write 'TODO', @todo.map { |item| "[ ] #{item}" }.join("\n") + "\n"

# setup git
git :init
git add: '-A'
git commit: '-m "initial commit"'
