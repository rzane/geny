require "geny/dsl"
require "geny/context/invoke"

module Geny
  class Command
    # The filename for a generator, relative to the root
    FILENAME = "generator.rb"

    # The directory where templates are stored, relative to the root
    TEMPLATES = "templates"

    # The name of the command
    # @return [String]
    attr_reader :name

    # The root directory for the command
    # @return [String]
    attr_reader :root

    # Create a new command
    # @param name [String] name of the command
    # @param root [String] name of the command
    def initialize(name:, root:)
      @name = name
      @root = root
    end

    # The path where the command is located
    # @return [String]
    def file
      File.join(root, FILENAME)
    end

    # The path where templates are located
    # @return [String]
    def templates_path
      File.join(root, TEMPLATES)
    end

    # The command's option parser
    # @return [Argy::Parser]
    def parser
      dsl.parser
    end

    # The command's helper modules
    # @return [Array<Module>]
    def helpers
      dsl.helpers
    end

    # The description for a command
    # @return [String]
    def description
      parser.description
    end

    # Parse command-line options
    # @param argv [Array<String>]
    # @return [Argy::Options]
    def parse(argv)
      parser.parse(argv)
    end

    # Parse command-line options and run the command
    # @param argv [Array<String>]
    def run(argv)
      options = parse(argv)
      invoke!(options.to_h)
    end

    # Invoke a command with options
    # @param options [Hash{Symbol => Object}]
    def invoke(**options)
      options = parser.default_values.merge(options)
      parser.validate!(options)
      invoke!(options)
    end

    # Defines the behavior of a command. The block is evaluated
    # within the context of a DSL.
    #
    # @example
    #   command = Commmand.new(name: "foo", root: "path/to/root")
    #   command.define do
    #     parse {}
    #     invoke {}
    #   end
    def define(&block)
      @dsl = DSL.new
      @dsl.instance_eval(&block)
      self
    end

    private

    def invoke!(options)
      context = Context::Invoke.new(
        command: self,
        locals: extend_with_queries(options)
      )

      context.instance_eval(&dsl.invoke)
    end

    def extend_with_queries(options)
      queries = options.map { |k, v| [:"#{k}?", !!v] }
      options.merge(queries.to_h)
    end

    def dsl
      return @dsl if @dsl

      @dsl = DSL.new
      @dsl.instance_eval File.read(file)
      @dsl
    end
  end
end
