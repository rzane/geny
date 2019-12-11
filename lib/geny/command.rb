require "geny/dsl"
require "geny/context/invoke"

module Geny
  class Command
    attr_reader :name, :file

    def initialize(name:, file:)
      @name = name
      @file = file
    end

    def helpers
      dsl.helpers
    end

    def templates_path
      File.expand_path("../templates", file)
    end

    def description
      dsl.parser.description
    end

    def parse(argv)
      dsl.parser.parse(argv)
    end

    def run(argv)
      invoke parse(argv).to_h
    end

    def invoke(**options)
      context = Context::Invoke.new(
        command: self,
        locals: extend_with_queries(options)
      )

      context.instance_eval(&dsl.invoke)
    end

    private

    def extend_with_queries(options)
      queries = options.map { |k, v| [:"#{k}?", !!v] }
      options.merge(queries.to_h)
    end

    def dsl
      @dsl ||= load!
    end

    def load!
      input = File.read(file)

      dsl = DSL.new
      dsl.instance_eval(input)
      dsl
    end
  end
end
