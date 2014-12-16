# general configuration tuning
application <<-RUBY
config.generators do |g|
      g.helper false
      g.assets false
      g.test_framework :rspec, fixture: false
    end
RUBY

# rotate logs in development/test environments
%w[development test].each do |env|
  environment <<-RUBY, env: env
# rotate logs when the grow to 5 MB, keep only the 5 most recent files
  config.logger = Logger.new(Rails.root.join('log', Rails.env + '.log'), 5, 5_000_000)
  RUBY
end
append_file '.gitignore', "/log/*.log.*\n"

# always use ssl in production
uncomment_lines 'config/environments/production.rb', /config\.force_ssl = true/
