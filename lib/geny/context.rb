require "geny/ui"
require "geny/git"
require "geny/shell"
require "geny/files"
require "geny/templates"

require "active_support/core_ext/string/indent"
require "active_support/core_ext/string/inflections"

module Geny
  class Context
    attr_reader :ui, :files, :shell, :git, :templates

    def initialize(file:, locals:, helpers: [])
      @locals = locals

      @ui = UI.new
      @files = Files.new
      @shell = Shell.new(ui: ui)
      @git = Git.new(shell: shell)
      @templates = Templates.new(root: File.expand_path("../templates", file))

      helpers.each { |helper| extend helper }
    end

    private

    def respond_to_missing?(name, *)
      @locals.key?(name) || super
    end

    def method_missing(name, *args)
      return super unless @locals.key?(name)

      unless args.empty?
        raise ArgumentError, "wrong number of arguments (given #{args.length}, expected 0)"
      end

      @locals[name]
    end
  end
end
