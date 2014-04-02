inject_into_file 'app/controllers/application_controller.rb',
  "  after_action ->{ GC::OOB.run }\n",
  after: "protect_from_forgery with: :exception\n"
inject_into_file 'config.ru', <<-RUBY, before: 'run Rails.application'
require 'gctools/oobgc'
if defined?(Unicorn::HttpRequest)
  use GC::OOB::UnicornMiddleware
end
RUBY
template 'env', '.env'
@todo << "Set RUBY_GC_HEAP vars in production/staging with heroku config:set"
