warn <<-END
DEPRECATION WARNING: Use 'rails --skip-turbolinks' option instead.
  => https://github.com/rails/rails/commit/bf17c8a531bc8059d50ad731398002a3e7162a7d
END
# To date, turbolinks has only ever made things break faster for me.
gsub_file 'Gemfile', "gem 'turbolinks'", "# gem 'turbolinks'"

gsub_file 'app/assets/javascripts/application.js',
  "//= require turbolinks\n",
  ''

# The application layout in templates/application.html.haml is insatlled
# later, but it has already been stripped of turbolinks.
