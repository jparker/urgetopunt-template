@test_framework = yes?('Use rspec?') ? :rspec : :test_unit

def rspec?
  @test_framework == :rspec
end
