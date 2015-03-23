copy_file 'app/assets/stylesheets/application.css',
  'app/assets/stylesheets/application.css.scss'
remove_file 'app/assets/stylesheets/application.css'

append_file 'app/assets/stylesheets/application.css.scss', <<-SCSS
// Uncomment and change this value to tweak font sizes globally.
// $font-base-size: 12px;

@import 'bootstrap';
@import 'bootstrap/theme';
@import 'font-awesome-sprockets';
@import 'font-awesome';

// Add a top margin to the body if using navbar fixed to the top of the page
// body {
//   margin-top: 60px;
// }
SCSS

inject_into_file 'app/assets/javascripts/application.js', before: %r{//= require_tree .} do
  "//= require bootstrap\n"
end

remove_file 'app/views/layouts/application.html.erb'
template 'application.html.haml', 'app/views/layouts/application.html.haml'

template 'flash_helper.rb', 'app/helpers/flash_helper.rb'
template 'alert.html.haml', 'app/views/application/_alert.html.haml'
template 'flash.html.haml', 'app/views/application/_flash.html.haml'

# configure kaminari
generate 'kaminari:config'
# generate 'kaminari:views', 'bootstrap'

# configure simple_form
generate 'simple_form:install', '--bootstrap'
template 'citext_input.rb', 'app/inputs/citext_input.rb'
