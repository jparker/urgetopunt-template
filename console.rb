create_file '.pryrc', <<-RUBY
AwesomePrint.pry!

if defined?(Rails)
  Pry.config.prompt = lambda do |obj, nest_level, _|
    "\#{app_name}/\#{env_name} \#{obj}:\#{nest_level}> "
  end
end

def app_name
  ENV['HEROKU_APP_NAME'][/\A(.*)-/, 1]
end

def env_name
  ENV['HEROKU_APP_NAME'].match /-([[:alpha:]]+)\z/ do |m|
    case m[1]
    when 'development'
      Pry::Helpers::Text.bright_green m[1]
    when 'test'
      Pry::Helpers::Text.bright_blue m[1]
    when 'staging'
      Pry::Helpers::Text.bright_yellow m[1]
    when 'production'
      Pry::Helpers::Text.bright_red m[1]
    else
      Pry::Helpers::Text.bright_default m[1]
    end
  end
end
RUBY
