require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "bundler/setup"
require "geny"
require "pry"

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

  def tmp
    @tmp ||= Pathname.new(Dir.mktmpdir)
  end

  def purge_tmp
    @tmp.rmtree if defined?(@tmp)
  end

  def write(filename, content = "")
    path = tmp.join(filename)
    path.parent.mkpath
    path.write(content)
  end
end

RSpec.configure do |config|
  config.include Helpers

  config.after :each do
    purge_tmp
  end

  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
