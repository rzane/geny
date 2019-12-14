require "pastel"
require "geny/context/base"
require "geny/actions/ui"
require "geny/actions/geny"
require "geny/actions/git"
require "geny/actions/shell"
require "geny/actions/files"
require "geny/actions/find"
require "geny/actions/templates"

module Geny
  module Context
    # The `invoke` behavior for all commands is evaluated in
    # the context of this class. All methods that are defined
    # here are available inside `invoke`.
    class Invoke < Base
      # A utility for colored output
      # @return [Pastel]
      # @see https://github.com/piotrmurach/pastel
      def color
        Pastel.new(enabled: $stdout.tty?)
      end

      # A utility for printing messages to the console
      # @return [Actions::UI]
      def ui
        Actions::UI.new(color: color)
      end

      # A utility for interacting with files
      # @return [Actions::Files]
      def files
        Actions::Files.new
      end

      # A utility for bulk find-and-replace operations
      # @return [Actions::Find]
      def find
        Actions::Find.new
      end

      # A utility for running shell commands
      # @return [Actions::Shell]
      def shell
        Actions::Shell.new(ui: ui)
      end

      # A utility for interacting with git repositories
      # @return [Actions::Git]
      def git
        Actions::Git.new(shell: shell)
      end

      # A utility for rendering and copying templates
      # @return [Actions::Templates]
      def templates
        Actions::Templates.new(
          root: command.templates_path,
          view: View.new(command: command, locals: locals)
        )
      end

      # A utility for invoking other generators
      # @return [Actions::Geny]
      def geny
        Actions::Geny.new(registry: command.registry)
      end
    end
  end
end
