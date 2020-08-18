module Geny
  module Actions
    # Run Geny commands from within a Geny invocation. Whoa, meta.
    class Geny
      # Create a new Geny
      # @param registry [Registry]
      def initialize(registry:)
        @registry = registry
      end

      # Run a command with arguments
      # @param name [String] name of the command
      # @param argv [Array<String>] command-line arguments
      #
      # @example
      #   geny.run "rails:model", "--name", "User"
      def run(name, *argv)
        command = @registry.find!(name)
        command.run(argv)
      end

      # Run a command with options
      # @param name [String] name of the command
      # @param options [Hash{Symbol => Object}] options for the command
      #
      # @example
      #   geny.invoke "rails:model", name: "User"
      def invoke(name, **options)
        command = @registry.find!(name)
        command.invoke(**options)
      end
    end
  end
end
