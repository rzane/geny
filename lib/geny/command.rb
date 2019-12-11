require "forwardable"
require "geny/dsl"
require "geny/context/invoke"

module Geny
  class Command
    extend Forwardable

    FILENAME = "generator.rb"
    TEMPLATES = "templates"

    attr_reader :name, :root

    def_delegators :dsl, :parser, :helpers
    def_delegators :parser, :description, :parse

    def initialize(name:, root:)
      @name = name
      @root = root
    end

    def define(&block)
      @dsl = DSL.new
      @dsl.instance_eval(&block)
    end

    def file
      File.join(root, FILENAME)
    end

    def templates_path
      File.join(root, TEMPLATES)
    end

    def run(argv)
      options = parse(argv)
      invoke!(options.to_h)
    end

    def invoke(**options)
      parser.validate!(options)
      invoke!(options)
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
