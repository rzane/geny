require "bundler/setup"
require_relative "support/coverage"
require "geny"
require "file_spec"

module Helpers
  def module_double(opts)
    mod = Module.new
    opts.each do |key, value|
      if value.respond_to?(:call)
        mod.define_method(key, &value)
      else
        mod.define_method(key) { value }
      end
    end
    mod
  end
end

RSpec.configure do |config|
  config.include Helpers
  config.include FileSpec

  config.around :each do |example|
    begin
      example.run
    rescue SystemExit => error
      fail "exited with status #{error.status}"
    end
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
