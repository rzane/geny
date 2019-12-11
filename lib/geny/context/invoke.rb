require "geny/actions/ui"
require "geny/actions/git"
require "geny/actions/shell"
require "geny/actions/files"
require "geny/actions/templates"
require "geny/context/base"

module Geny
  module Context
    class Invoke < Base
      def color
        Pastel.new(enabled: $stdout.tty?)
      end

      def ui
        Actions::UI.new(color: color)
      end
      delegate_all Actions::UI, to: :ui

      def files
        Actions::Files.new
      end
      delegate_all Actions::Files, to: :files

      def shell
        Actions::Shell.new(ui: ui)
      end
      delegate_all Actions::Shell, to: :shell

      def git
        Actions::Git.new(shell: shell)
      end
      delegate_all Actions::Git, to: :git, prefix: :git

      def templates
        Actions::Templates.new(locals: locals, helpers: helpers)
      end
      delegate_all Actions::Templates, to: :templates
    end
  end
end
