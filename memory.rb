inject_into_file 'app/controllers/application_controller.rb', before: /end\z/ do
  "\n  after_action ->{ GC::OOB.run }\n"
end

inject_into_file 'config.ru', before: 'run Rails.application' do
  <<-RUBY

require 'gctools/oobgc'
if defined?(Unicorn::HttpRequest)
  use GC::OOB::UnicornMiddleware
end

  RUBY
end

template 'env', '.env'
@todo << '`heroku config:set RUBY_GC_HEAP_*` to tune gc and memory usage'
