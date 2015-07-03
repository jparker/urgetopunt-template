generate 'exception_notification:install'

route "get 'test/exception' => 'test#exception'"
generate 'controller', 'test'
inject_into_file 'app/controllers/test_controller.rb', before: /end/ do
  "  def exception; raise 'test exception notification'; end\n"
end

@todo << 'Update config/initializers/exception_notification.rb and perform a GET /test/exception'
