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

append_to_file '.env', <<-END
RUBY_GC_HEAP_FREE_SLOTS=100000
RUBY_GC_HEAP_GROWTH_FACTOR=1.25
RUBY_GC_HEAP_GROWTH_MAX_SLOTS=600000
RUBY_GC_HEAP_OLDOBJECT_LIMIT_FACTOR=1.5
END

@todo << '`heroku config:set RUBY_GC_HEAP_*` to tune gc and memory usage'
