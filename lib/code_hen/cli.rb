require "code_hen"
require "code_hen/dsl"
require "code_hen/parser"
require "code_hen/generator"

module CodeHen
  class CLI
    MANIFEST = "generator.rb"
    ROOTS = [File.expand_path("../generators", __dir__)]

    def self.run(*args)
      new(*args).run
    end

    def initialize(roots: ROOTS, argv: ARGV, version: CodeHen::VERSION)
      @argv = argv
      @roots = roots
      @version = version
    end

    def run
      abort "You need to provide the name of a generator." if name.nil?
      abort "I wasn't able to find a generator named '#{name}'" if manifest.nil?

      dsl = DSL.new
      dsl.instance_eval File.read(manifest)

      parser = Parser.new
      parser.instance_eval(&dsl.parse)

      context = parser.parse(@argv)
      generator = Generator.new(context: context)
      dsl.helpers.each { |h| generator.extend(h) }
      generator.instance_eval(&dsl.invoke)
    end

    private

    def name
      @argv.first
    end

    def path
      name.split(":")
    end

    def args
      @argv[1..-1]
    end

    def manifest_locations
      @roots.map { |root| File.join(root, *path, MANIFEST) }
    end

    def manifest
      @manifest ||= manifest_locations.find { |m| File.exist?(m) }
    end
  end
end
