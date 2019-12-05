require "slop"
require "code_hen"
require "code_hen/dsl"
require "code_hen/generator"

module CodeHen
  class CLI
    MANIFEST = "generate.rb"
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

      opts = Slop.parse(args) do |o|
        dsl.parse.call(o)

        o.on("-v", "--version", "show the version and exit") do
          puts @version
          exit
        end

        o.on("-h", "--help", "show this help and exit") do
          puts o
          exit
        end
      end

      generator = Generator.new(context: opts.to_hash)
      dsl.helpers.each do |helper|
        generator.extend helper
      end
      generator.instance_eval(&dsl.invoke)
    end

    private

    def name
      @argv.first
    end

    def path
    end

    def args
      @argv[1..-1]
    end

    def manifest_locations
      path = name.split(":")

      @roots.flat_map { |root|
        [
          File.join(root, *path, MANIFEST),
          File.join(root, *path[0..-2], "#{path[-1]}.#{MANIFEST}")
        ]
      }
    end

    def manifest
      @manifest ||= manifest_locations.find { |m| File.exist?(m) }
    end
  end
end
