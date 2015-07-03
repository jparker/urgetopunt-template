generate 'exception_notification:install'

generate 'controller', 'exception'
route "get 'exception/test' => 'exception#test'"
inject_into_file 'app/controllers/exception_controller.rb', before: /end/ do
  "  def test; raise 'test exception notification'; end\n"
end

@todo << 'Update config/initializers/exception_notification.rb and perform a GET /test/exception'
