initializer 'timeout.rb', <<-RUBY
Rack::Timeout.timeout = 20 # seconds
if Rails.env.development?
  Rack::Timeout::Logger.disable
end
RUBY

append_file 'Procfile', "web: bundle exec puma -C config/puma.rb\n"
create_file 'Procfile.development', "web: bundle exec puma -C config/puma.rb -b tcp://127.0.0.1:$PORT/\n"
append_file '.env', "PORT=5000\n"
