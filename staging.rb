# copy_file 'config/environments/production.rb', 'config/environments/staging.rb'
in_root {
  FileUtils.cp 'config/environments/production.rb',
    'config/environments/staging.rb'
}
gsub_file 'config/environments/staging.rb',
  /#{app_name}-production\./,
  "#{app_name}-staging."
