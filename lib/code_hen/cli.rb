require "code_hen/dsl"

module CodeHen
  class CLI
    MANIFEST = "code_hen.rb"
    ROOTS = [File.join(__dir__, "generators")]

    def self.run(*args)
      new(*args).run
    end

    def initialize(roots: ROOTS, argv: ARGV, version: CodeHen::VERSION)
      @dsl = DSL.new
      @argv = argv
      @roots = roots
      @version = version
    end

    def run
      if @argv.empty?
        abort "You need to provide the name of a generator."
      end

      name, *args = @argv
      path = name.split(":")
      manifests = @roots.map { |root| File.join(root, *path, MANIFEST) }
      manifest = manifests.find { |manifest| File.exist?(manifest) }

      if manifest.nil?
        abort "I wasn't able to find a generator named '#{name}'."
      end

      @dsl.instance_eval File.read(manifest)

      opts = Slop.parse(args) do |o|
        @dsl.parse.call(o)

        o.on("-v", "--version", "show the version and exit") do
          puts @version
          exit
        end

        o.on("-h", "--help", "show this help and exit") do
          puts o
          exit
        end
      end

      @dsl.helpers.each do |helper|
        opts.extend helper
      end

      opts.instance_eval(&@dsl.generate)
    end
  end
end
