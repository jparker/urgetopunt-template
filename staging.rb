# Using #copy_file below uses a template version of produciont.rb from the
# source path not the version that has already been installed.
# copy_file 'config/environments/production.rb', 'config/environments/staging.rb'
in_root {
  FileUtils.cp 'config/environments/production.rb', 'config/environments/staging.rb'
}

gsub_file 'config/environments/staging.rb',
  /#{app_name}-production/, "#{app_name}-staging"

require 'yaml'

secrets = YAML.load_file 'config/secrets.yml'
append_file 'config/secrets.yml',
  { 'staging' => secrets['production'] }.to_yaml.sub(/\A---/, '')
