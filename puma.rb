initializer 'timeout.rb', "Rack::Timeout.timeout = 20 # seconds\n"

create_file 'config/puma.rb', <<-RUBY
# Configuration based on Heroku recommendations:
#
# https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server

max_threads = Integer(ENV['MAX_THREADS'] || 5)
min_threads = Integer(ENV['MIN_THREADS'] || max_threads)

workers Integer(ENV['WEB_CONCURRENCY'] || 3)
threads min_threads, max_threads

preload_app!

rackup      DefaultRackup
port        ENV['PORT'] || 3000
environment ENV['RACK_ENV'] || 'development'

on_worker_boot do
  ActiveRecord::Base.establish_connection
end
RUBY

append_file 'Procfile', "web: bundle exec puma -C config/puma.rb\n"
append_file '.env', "WEB_CONCURRENCY=3\nMAX_THREADS=5\n"
