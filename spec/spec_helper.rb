require "bundler/setup"
require "geny"
require "pry"

module TemporaryFileHelpers
  def self.included(base)
    base.let(:tmp)    { Pathname.new(Dir.mktmpdir) }
    base.after(:each) { tmp.rmtree }
  end

  def write(filename, content = "")
    path = tmp.join(filename)
    path.parent.mkpath
    path.write(content)
  end
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
