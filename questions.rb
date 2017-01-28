@test_framework = yes?('Use rspec?') ? :rspec : :minitest

def rspec?
  :rspec == @test_framework
end
