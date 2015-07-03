@test_framework = yes?('Use rspec?') ? :rspec : :minitest
@app_server     = yes?('Use puma?') ? :puma : :unicorn

def rspec?
  :rspec == @test_framework
end

def puma?
  :puma == @app_server
end
