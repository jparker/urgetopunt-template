RSpec::Matchers.define :have_flash do |key, **options|
  match do |node|
    key.match /\Aflash\.(.*?)\.(.*\..*)\z/ do |m|
      options.reverse_merge! resource_name: m[1].classify.underscore.humanize,
        default: %I[flash.actions.#{m[2]}]
    end

    @node = node
    @content = I18n.t key, **options

    @node.has_content? @content
  end

  failure_message do
    "expected to find text '#{@content}' in '#{@node.text}'"
  end

  failure_message_when_negated do
    "expected to NOT find text '#{@content}' in '#{@node.text}'"
  end
end
