require "geny/actions/ui"
require "geny/actions/git"
require "geny/actions/shell"
require "geny/actions/files"
require "geny/actions/templates"

require "active_support/core_ext/string/indent"
require "active_support/core_ext/string/inflections"

module Geny
  class Context
    attr_reader :command, :locals

    def initialize(command, locals: {})
      @command = command
      @locals = locals

      command.helpers.each { |helper| extend helper }
    end

    def ui
      UI.new
    end

    def files
      Files.new
    end

    def shell
      Shell.new(ui: ui)
    end

    def git
      Git.new(shell: shell)
    end

    def templates
      Templates.new(root: command.templates_path)
    end

    def merge(updates)
      Context.new(command, locals: locals.merge(updates))
    end

    private

    def respond_to_missing?(name, *)
      locals.key?(name) || super
    end

    def method_missing(name, *args)
      return super unless locals.key?(name)

      unless args.empty?
        raise ArgumentError, "wrong number of arguments (given #{args.length}, expected 0)"
      end

      locals[name]
    end
  end
end
