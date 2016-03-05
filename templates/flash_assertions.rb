module FlashAssertions
  def self.included(cls)
    cls.infect_an_assertion :assert_flash, :must_have_flash
    cls.infect_an_assertion :refute_flash, :wont_have_flash
  end

  def assert_flash(key, node, **options)
    add_responders_options! key, options
    assert_content node, I18n.t!(key, **options)
  end

  def refute_flash(key, node, **options)
    add_responders_options! key, options
    refute_content node, I18n.t!(key, **options)
  end

  def add_responders_options!(key, options)
    key.match /\Aflash\.(.*)\.(create|update|destroy)\.(notice|alert)\z/ do |m|
      options.update \
        resource_name: m[1].split('.').last.classify,
        default: %I[flash.actions.#{m[2]}.#{m[3]}]
    end
  end
end
