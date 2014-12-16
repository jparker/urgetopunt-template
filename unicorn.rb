template 'unicorn.rb', 'config/unicorn.rb'

create_file 'Procfile', "web: bundle exec unicorn -p $PORT -c ./config/unicorn.rb\n"
