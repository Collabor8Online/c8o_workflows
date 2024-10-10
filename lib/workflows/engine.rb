module Workflows
  class Engine < ::Rails::Engine
    isolate_namespace Workflows
    config.generators do |g|
      g.test_framework :rspec
      g.assets false
      g.helper false
    end
  end
end
