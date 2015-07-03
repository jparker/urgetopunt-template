# only use gctools on ruby < 2.2.0
if RUBY_VERSION.match /\A2\.[01]\./
  inject_into_file 'app/controllers/application_controller.rb', before: /end\z/ do
    "\n  after_action ->{ GC::OOB.run }\n"
  end

  inject_into_file 'config.ru', "\nrequire 'gctools/oobgc'\n", before: 'run Rails.application'

  if puma?
    inject_into_file 'config.ru', "use GC::OOB::PumaMiddleware\n", before: 'run Rails.application'
  else
    inject_into_file 'config.ru', "use GC::OOB::UnicornMiddleware\n", before: 'run Rails.application'
  end
end

append_to_file '.env', <<-END
RUBY_GC_HEAP_FREE_SLOTS=100000
RUBY_GC_HEAP_GROWTH_FACTOR=1.25
RUBY_GC_HEAP_GROWTH_MAX_SLOTS=600000
RUBY_GC_HEAP_OLDOBJECT_LIMIT_FACTOR=1.5
END

@todo << '`heroku config:set RUBY_GC_HEAP_*` to tune gc and memory usage'
