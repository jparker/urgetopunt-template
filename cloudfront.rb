comment_lines 'config/environments/production.rb', /config\.serve_static_assets = false/

environment <<RUBY, env: 'production'
# Enable serving of static assets to lazily feed Cloudfront from app
  config.serve_static_assets = true
RUBY

environment <<RUBY, env: 'production'
config.middleware.insert_before ActionDispatch::Static, Rack::Cors do
    allow do
      origins 'https://#{app_name}-production.herokuapp.com'
      resource '/assets/*', headers: :any, methods: [:get, :head]
    end
  end
RUBY

@todo << 'Set asset_host in production.rb to cloudfront distro'
