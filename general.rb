# general configuration tuning
application <<-RUBY

    config.generators do |g|
      g.helper false
      g.assets false
      g.test_framework :rspec, fixture: false
    end
RUBY

# Use SQL schema to preserve advanced postgresql features. In production
# this must be "disabled" to prevent a harmless but annoying exception when
# running migrations on Heroku.
application 'config.active_record.schema_format = :sql'
environment 'config.active_record.schema_format = :ruby', env: 'production'

# rotate logs in development/test environments
%w[development test].each do |env|
  environment "config.logger = Logger.new(Rails.root.join('log', Rails.env + '.log'), 5, 5*1_024*1_024)",
    env: env
end
append_file '.gitignore', "/log/*.log.*\n"

# always use ssl in production
gsub_file 'config/environments/production.rb',
  '# config.force_ssl = true',
  'config.force_ssl = true'
