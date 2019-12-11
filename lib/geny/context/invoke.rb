require "forwardable"
require "geny/actions/ui"
require "geny/actions/git"
require "geny/actions/shell"
require "geny/actions/files"
require "geny/actions/templates"

module Geny
  module Context
    class Invoke
      extend Forwardable

      def self.delegate_all(klass, to:, prefix: nil)
        names = klass.instance_methods - Object.instance_methods
        names.each do |name|
          def_delegator(to, name, prefix ? "#{prefix}_#{name}" : name)
        end
      end

      attr_reader :options, :color

      delegate_all Actions::UI, to: :@ui
      delegate_all Actions::Files, to: :@files
      delegate_all Actions::Shell, to: :@shell
      delegate_all Actions::Git, to: :@git, prefix: :git
      delegate_all Actions::Templates, to: :@templates

      def initialize(command:, options:)
        @options = options
        @color = Pastel.new(enabled: $stdout.tty?)
        @ui = Actions::UI.new(color: @color)
        @files = Actions::Files.new
        @shell = Actions::Shell.new(ui: @ui)
        @git = Actions::Git.new(shell: @shell)

        @templates = Actions::Templates.new(
          root: command.templates_path,
          view: View.new(
            helpers: command.helpers,
            locals: {options: options}
          )
        )

        command.helpers.each { |h| extend h }
      end

      def locals
        {options: options}
      end
    end
  end
end
