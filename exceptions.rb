generate 'exception_notification:install'

generate 'controller', 'exception'
route "get 'exception/test' => 'exception#test'"
inject_into_file 'app/controllers/exception_controller.rb', before: /end/ do
  <<-RUBY
  def test
    raise 'This action deliberately raises a RuntimeError' \\
      ' in order to test exception notification.'
  end
  RUBY
end

gsub_file 'test/controllers/exception_controller_test.rb',
  /test_sanity\n(\s+)flunk "Need real tests"/,
  "test_exception_notification\n#{$1}assert_raises(RuntimeError) { get :test }"

@todo << 'Update config/initializers/exception_notification.rb and perform a GET /test/exception'
