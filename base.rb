# rails new APP_NAME --skip-bundle --skip-test-unit [-d postgresql]

@todo = []

def source_paths
  [File.join(File.dirname(__FILE__), 'templates'), *super]
end

# set ruby version
inject_into_file 'Gemfile', "ruby '#{RUBY_VERSION}'\n", after: /\Asource .*\n/

apply File.join(File.dirname(__FILE__), 'gems.rb')
apply File.join(File.dirname(__FILE__), 'general.rb')
apply File.join(File.dirname(__FILE__), 'cloudfront.rb')
apply File.join(File.dirname(__FILE__), 'sendgrid.rb')
apply File.join(File.dirname(__FILE__), 'staging.rb')
apply File.join(File.dirname(__FILE__), 'unicorn.rb')
apply File.join(File.dirname(__FILE__), 'bootstrap.rb')
apply File.join(File.dirname(__FILE__), 'memory.rb')
apply File.join(File.dirname(__FILE__), 'rspec.rb')
apply File.join(File.dirname(__FILE__), 'exceptions.rb')

# spring-ify commands
run 'bundle exec spring binstub --all'

# setup git
git :init
git add: '-A'
git commit: '-m "initial commit"'
@todo << "Setup git remotes: 'git remote add origin git@github.com:...'"

@todo.each do |item|
  puts "[ ] #{item}"
end
