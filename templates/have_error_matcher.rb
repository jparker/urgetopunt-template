RSpec::Matchers.define :have_error do |message, on:|
  field_label_or_id = on

  match do |node|
    group = node.find_field(field_label_or_id)
    begin
      group = group.find(:xpath, '..')
    end until group[:class].to_s.include?('form-group')
    group.has_content?(message)
  end

  failure_message do
    "expected to find text '#{message}' under '#{field_label_or_id}' in '#{page.text}'"
  end
end
