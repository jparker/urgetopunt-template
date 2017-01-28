RSpec::Matchers.define :have_error do |message, on:|
  match do |node|
    @group = node.find_field on

    # Locate the form-group container
    begin
      @group = @group.find :xpath, '..'
    end until @group[:class].to_s.include?('form-group')

    @group.has_content? message
  end

  failure_message do
    "expected to find text '#{message}' in '#{@group.text}'"
  end

  failure_message_when_negated do
    "expected NOT to find text '#{message}' in '#{@group.text}'"
  end
end
