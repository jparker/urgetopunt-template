# general configuration tuning
application <<-RUBY
config.generators do |g|
      g.helper false
      g.assets false
    end
RUBY

# rotate logs in development/test environments
%w[development test].each do |env|
  environment <<-RUBY, env: env
# Rotate logs when the grow to 5 MB, keep only the 5 most recent files.
  config.logger = ActiveSupport::Logger.new \
    Rails.root.join('log', Rails.env + '.log'), 5, 5*1_000*1_000
  RUBY
end
append_file '.gitignore', "/log/*.log.*\n"

# always use ssl in production
uncomment_lines 'config/environments/production.rb', /config\.force_ssl = true/

# raise error on missing translations in development and testing
%w[development test].each do |env|
  uncomment_lines "config/environments/#{env}.rb",
    /config.action_view.raise_on_missing_translations = true/
end
