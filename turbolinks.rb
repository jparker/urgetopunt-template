warn <<-END
DEPRECATION WARNING: Use 'rails --skip-turbolinks' option instead.
  => https://github.com/rails/rails/commit/bf17c8a531bc8059d50ad731398002a3e7162a7d
END
# To date, turbolinks has only ever made things break faster for me.
comment_lines 'Gemfile', /gem 'turbolinks'/

gsub_file 'app/assets/javascripts/application.js', "//= require turbolinks\n", ''
