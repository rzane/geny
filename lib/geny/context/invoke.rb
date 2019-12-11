require "geny/context/base"
require "geny/actions/ui"
require "geny/actions/git"
require "geny/actions/shell"
require "geny/actions/files"
require "geny/actions/templates"

module Geny
  module Context
    class Invoke < Base
      def color
        Pastel.new(enabled: $stdout.tty?)
      end

      def ui
        Actions::UI.new(color: color)
      end

      def files
        Actions::Files.new
      end

      def shell
        Actions::Shell.new(ui: ui)
      end

      def git
        Actions::Git.new(shell: shell)
      end

      def templates
        Actions::Templates.new(
          root: command.templates_path,
          view: View.new(command: command, locals: locals)
        )
      end
    end
  end
end
