require "bundler/setup"
require "geny"
require "pry"

module TemporaryFileHelpers
  def self.included(base)
    base.let(:tmp)    { Dir.mktmpdir }
    base.after(:each) { FileUtils.rm_rf(tmp) }
  end

  def join(filename)
    File.join(tmp, filename)
  end

  def write(filename, content = "")
    path = File.join(tmp, filename)
    FileUtils.mkdir_p File.dirname(path)
    File.write(path, content)
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
