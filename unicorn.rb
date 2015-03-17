create_file 'config/unicorn.rb', <<-RUBY
worker_processes Integer(ENV.fetch('WEB_CONCURRENCY', 3))
timeout 30
preload_app true

before_fork do |master, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM, sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info 'Unicorn master disconnected from database'
  end
end

after_fork do |master, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker ignoring TERM, waiting for QUIT from master'
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info 'Unicorn worker connected to database'
  end
end
RUBY

append_file 'Procfile', "web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb\n"
