module ErrorAssertions
  def self.included(cls)
    cls.infect_an_assertion :assert_has_error, :must_have_error
    cls.infect_an_assertion :refute_has_error, :wont_have_error
  end

  def assert_has_error(message, node, on:)
    field = find_form_group node, on
    assert field.has_content?(message),
      "expected '#{node.text}' to include '#{message}'"
  end

  def refute_has_error(message, node, on:)
    field = find_form_group node, on
    refute field.has_content?(message),
      "expected '#{node.text}' NOT to include '#{message}'"
  end

  def find_form_group(node, descriptor)
    field = node.find_field descriptor

    begin
      field = field.find :xpath, '..'
    end until field[:class]&.include? 'form-group'

    field
  end
end
