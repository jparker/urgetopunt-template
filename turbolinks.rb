# Turbolinks makes the javascript functionality in your application
# break faster.
gsub_file 'Gemfile', "gem 'turbolinks'", "# gem 'turbolinks'"

gsub_file 'app/assets/javascripts/application.js',
  "//= require turbolinks\n",
  ''

# The application layout in templates/application.html.haml is insatlled
# later, but it has already been stripped of turbolinks bloat.
