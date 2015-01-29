environment <<-RUBY, env: 'production'
# sendgrid configuration
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    address:              'smtp.sendgrid.net',
    port:                 '587',
    authentication:       :plain,
    user_name:            ENV['SENDGRID_USERNAME'],
    password:             ENV['SENDGRID_PASSWORD'],
    domain:               'heroku.com',
    enable_starttls_auto: true,
  }
  config.action_mailer.default_url_options = {
    host: '#{app_name}-production.herokuapp.com',
  }
RUBY
environment <<-RUBY, env: 'development'
config.action_mailer.default_url_options = {
    host: 'localhost',
    port: ENV.fetch('PORT', #{puma? ? 3000 : 5000}),
  }
RUBY
environment <<-RUBY, env: 'test'
config.action_mailer.default_url_options = {
    host: 'test.host'
  }
RUBY
