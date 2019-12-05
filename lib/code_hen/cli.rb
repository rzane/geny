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
      parser = Parser.new
      parser.version @version
      parser.argument :command, desc: "command to run", required: true

      options = parser.parse(@argv)
      command_name = options[:command]
      command_args = options[:unused_arguments]
      run_subcommand(command_name, command_args)
    end

    def run_subcommand(name, argv)
      manifest = find_manifest(name)

      dsl = DSL.new
      dsl.instance_eval File.read(manifest)

      parser = Parser.new
      parser.version @version
      parser.instance_eval(&dsl.parse)

      context = parser.parse(argv)
      generator = Generator.new(context: context)
      dsl.helpers.each { |h| generator.extend(h) }
      generator.instance_eval(&dsl.invoke)
    end

    private

    def find_manifest(command)
      path = command.split(":")
      paths = @roots.map { |root| File.join(root, *path, MANIFEST) }
      paths.find { |m| File.exist?(m) } || invalid_command!(command)
    end

    def invalid_command!(command)
      raise Error, "There doesn't appear to be a generator named '#{command}'."
    end
  end
end
