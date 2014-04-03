gsub_file 'config/environments/production.rb',
  'config.serve_static_assets = false',
  'config.serve_static_assets = true'
environment <<-RUBY, env: 'production'

  config.middleware.insert_before ActionDispatch::Static, Rack::Cors do
    allow do
      origins 'https://#{app_name}-production.herokuapp.com'
      resource '/assets/*', headers: :any, methods: [:get, :head]
    end
  end
RUBY

@todo << 'Set asset_host in production.rb to cloudfront distro'
