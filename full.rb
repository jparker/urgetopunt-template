# rails new APP_NAME --skip-bundle [--skip-test-unit] [--skip-turbolinks] [-d postgresql]

@todo = []

def source_paths
  [File.join(__dir__, 'templates'), *super]
end

apply File.join __dir__, 'base_pre.rb'
apply File.join __dir__, 'questions.rb'
apply File.join __dir__, 'gems.rb'

# install gems
bundle_opts = ENV.fetch('BUNDLE_OPTS') { '-j2' }
run "bundle install #{bundle_opts}"

apply File.join __dir__, 'general.rb'
apply File.join __dir__, 'console.rb'
apply File.join __dir__, 'cloudfront.rb'
apply File.join __dir__, 'sendgrid.rb'

if puma?
  apply File.join __dir__, 'puma.rb'
else
  apply File.join __dir__, 'unicorn.rb'
end

apply File.join __dir__, 'views.rb'
apply File.join __dir__, 'pages.rb'
apply File.join __dir__, 'memory.rb'

if rspec?
  apply File.join __dir__, 'rspec.rb'
else
  apply File.join __dir__, 'minitest.rb'
end

apply File.join __dir__, 'exceptions.rb'
apply File.join __dir__, 'responders.rb'
apply File.join __dir__, 'postgresql.rb'

# Should be applied after all other changes to config/environments/production.rb
apply File.join __dir__, 'staging.rb'

@todo << "Setup git remotes: 'git remote add origin git@github.com:...'"

File.write 'TODO', @todo.map { |item| "[ ] #{item}" }.join("\n") + "\n"

apply File.join __dir__, 'base_post.rb'
