require "code_hen/dsl"
require "code_hen/error"
require "code_hen/parser"
require "code_hen/generator"

module CodeHen
  class Command
    attr_reader :name, :load_path

    def initialize(name:, load_path:)
      @name = name
      @dsl = DSL.new
      @parser = Parser.new
      @loaded = false
      @load_path = load_path
    end

    def run(argv)
      load! unless loaded?
      invoke parser.parse(argv)
    end

    def invoke(context)
      load! unless loaded?
      generator = Generator.new(context: context)
      dsl.helpers.each { |h| generator.extend(h) }
      generator.instance_eval(&dsl.invoke)
    end

    private

    attr_reader :dsl, :parser, :load_path

    def loaded?
      @loaded
    end

    def load!
      @loaded = load_path.any? { |path|
        file = File.join(path, *name.split(":"), "generator.rb")
        data = begin
                 File.read(file)
               rescue Errno::ENOENT
                 next false
               end

        dsl.instance_eval(data)
        parser.instance_eval(&dsl.parse)
        true
      }

      command_not_found! unless loaded?
    end

    def command_not_found!
      raise NotFoundError, "There doesn't appear to be a generator named '#{name}'."
    end
  end
end
