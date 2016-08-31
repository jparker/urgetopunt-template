module ErrorAssertions
  def self.included(cls)
    cls.infect_an_assertion :assert_has_error, :must_have_error
    cls.infect_an_assertion :refute_has_error, :wont_have_error
  end

  def assert_has_error(message, node, on:, **options)
    field = find_form_group node, on, options
    assert field.has_content?(message),
      "expected '#{field.text}' to include '#{message}'"
  end

  def refute_has_error(message, node, on:, **options)
    field = find_form_group node, on, options
    refute field.has_content?(message),
      "expected '#{field.text}' NOT to include '#{message}'"
  end

  def find_form_group(node, descriptor, **options)
    field = node.find_field descriptor, options

    begin
      field = field.find :xpath, '..'
    end until field[:class]&.include? 'form-group'

    field
  end
end
