require 'rspec'

def require_files_from(paths = [])
  paths.each do |path|
    Dir[File.join(File.expand_path("#{path}*.rb", __FILE__))].sort.each do |file|
      require file
    end
  end
end

RSpec.configure do |config|
  config.color = true

  require File.expand_path('../../lib/quick_store', __FILE__)
  require_files_from ["../support/**/"]

  config.include TestHelpers

  config.before(:all) { use_test_store }
  config.after(:all) { remove_test_files }
end
