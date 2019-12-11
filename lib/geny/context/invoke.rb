require "geny/actions/ui"
require "geny/actions/git"
require "geny/actions/shell"
require "geny/actions/files"
require "geny/actions/templates"
require "geny/context/base"

module Geny
  module Context
    class Invoke < Base
      def ui
        @ui ||= Actions::UI.new
      end

      def files
        @files ||= Actions::Files.new
      end

      def shell
        @shell ||= Actions::Shell.new(ui: ui)
      end

      def git
        @git ||= Actions::Git.new(shell: shell)
      end

      def templates
        @templates ||= Actions::Templates.new(
          locals: locals,
          helpers: helpers
        )
      end
    end
  end
end
