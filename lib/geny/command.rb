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
      dsl.parser.parse(argv).to_h
    end

    def run(argv)
      invoke parse(argv)
    end

    def invoke(**options)
      context = Context::Invoke.new(
        helpers: helpers,
        locals: options,
        templates_path: templates_path
      )

      context.instance_eval(&dsl.invoke)
    end

    private

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
