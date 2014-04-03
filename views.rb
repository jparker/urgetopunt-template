inject_into_file 'app/assets/javascripts/application.js',
  "//= require bootstrap\n",
  after: "//= require jquery_ujs\n"
copy_file 'app/assets/stylesheets/application.css',
  'app/assets/stylesheets/application.css.scss'
gsub_file 'app/assets/stylesheets/application.css.scss',
  "*= require_self\n *= require_tree .",
  "*= require_tree .\n *= require_self"
append_file 'app/assets/stylesheets/application.css.scss', <<-SCSS
@import 'bootstrap';

body {
  margin-top: 40px;
}
SCSS
remove_file 'app/assets/stylesheets/application.css'

remove_file 'app/views/layouts/application.html.erb'
template 'application.html.haml', 'app/views/layouts/application.html.haml'

template 'flash_helper.rb', 'app/helpers/flash_helper.rb'

# configure kaminari
generate 'kaminari:config'
# generate 'kaminari:views', 'bootstrap'
