require "pathname"
require "code_hen/dsl"
require "code_hen/error"
require "code_hen/parser"
require "code_hen/generator"

module CodeHen
  class Command
    FILENAME = "generator.rb"

    attr_reader :name, :load_path

    def self.scan(load_path: CodeHen.load_path)
      glob = File.join("**", FILENAME)

      load_path.flat_map do |path|
        path = Pathname.new(path)

        path.glob(glob).map do |file|
          name = file.relative_path_from(path).dirname
          name = name.to_s.tr(File::SEPARATOR, ":")
          Command.new(name: name, file: file.to_s)
        end
      end
    end

    def initialize(name:, load_path: [], file: nil)
      @name = name
      @file = file
      @load_path = load_path
      @dsl = DSL.new
      @parser = Parser.new
      @loaded = false
    end

    def description
      load! unless loaded?
      parser.description
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

    attr_reader :dsl, :parser, :load_path, :file

    def loaded?
      @loaded
    end

    def load!
      files = file ? [file] : load_path.map { |path|
        File.join(path, *name.split(":"), FILENAME)
      }

      @loaded = files.any? { |file| eval_file(file) }
      command_not_found! unless loaded?
    end

    def eval_file(file)
      input = begin
        File.read(file)
      rescue Errno::ENOENT
        return false
      end

      dsl.instance_eval(input)
      parser.instance_eval(&dsl.parse)
      true
    end

    def command_not_found!
      raise NotFoundError, "There doesn't appear to be a generator named '#{name}'."
    end
  end
end
