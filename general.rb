# general configuration tuning
application <<-RUBY

    config.generators do |g|
      g.helper false
      g.assets false
      g.test_framework :rspec, fixture: false
    end

    config.active_record.schema_format = :sql
RUBY

# rotate logs in development/test environments
%w[development test].each do |env|
  environment "config.logger = Logger.new(Rails.root.join('log', Rails.env + '.log'), 5, 5*1_024*1_024)",
    env: env
end

# silence harmless warning when running migrations on heroku
environment 'config.active_record.schema_format = :ruby', env: 'production'

# always use ssl in production
gsub_file 'config/environments/production.rb',
  '# config.force_ssl = true',
  'config.force_ssl = true'
