template 'unicorn.rb', 'config/unicorn.rb'

create_file 'Procfile', <<-RUBY
web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb
RUBY
