require "code_hen/dsl"
require "code_hen/generator"

module CodeHen
  class Command
    attr_reader :name, :file

    def initialize(name:, file:)
      @name = name
      @file = file
    end

    def description
      dsl.parser.description
    end

    def parse(argv)
      dsl.parser.parse(argv)
    end

    def run(argv)
      invoke parse(argv)
    end

    def invoke(context)
      gen = Generator.new(context: context)
      dsl.helpers.each { |h| gen.extend(h) }
      gen.instance_eval(&dsl.invoke)
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
