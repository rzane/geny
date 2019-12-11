require "geny/actions/ui"
require "geny/actions/git"
require "geny/actions/shell"
require "geny/actions/files"
require "geny/actions/templates"
require "geny/context/base"

module Geny
  module Context
    class Invoke < Base
      attr_reader :color

      delegate_all Actions::UI, to: :ui
      delegate_all Actions::Files, to: :files
      delegate_all Actions::Shell, to: :shell
      delegate_all Actions::Git, to: :git, prefix: :git
      delegate_all Actions::Templates, to: :templates

      def initialize(templates_path:, **opts)
        super(opts)

        @color = Pastel.new(enabled: $stdout.tty?)
        @ui = Actions::UI.new(color: @color)
        @files = Actions::Files.new
        @shell = Actions::Shell.new(ui: @ui)
        @git = Actions::Git.new(shell: @shell)
        @templates = Actions::Templates.new(root: templates_path, **opts)
      end
    end
  end
end
