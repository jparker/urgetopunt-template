comment_lines 'config/environments/production.rb', /config\.serve_static_assets = false/

@todo << '`heroku config:set RAILS_SERVE_STATIC_FILES=true` to feed cloudfront'

environment <<RUBY, env: 'production'
config.middleware.insert_before ActionDispatch::Static, Rack::Cors do
    allow do
      origins "https://\#{ENV['PUBLIC_SERVER_NAME']}"
      resource '/assets/*', headers: :any, methods: [:get, :head]
    end
  end

  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=\#{1.month}",
  }
RUBY

@todo << 'Set asset_host in production.rb to cloudfront distro'
