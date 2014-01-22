worker_processes Integer(ENV.fetch('WEB_CONCURRENCY') {3})
timeout          30
preload_app      true

before_fork do |server, worker|
  Signal.trap('TERM') do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
    Rails.logger.info 'Unicorn master disconnected from database'
  end

  sleep 1
end

after_fork do |server, worker|
  Signal.trap('TERM') do
    puts 'Unicorn worker intercepting TERM and doing nothing (waiting for master to send QUIT)'
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.establish_connection
    Rails.logger.info 'Unicorn worker connected to database'
  end
end
