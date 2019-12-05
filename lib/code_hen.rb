require "code_hen/version"

module CodeHen
  class Error < StandardError; end

  class CLI
    MANIFEST = "code_hen.rb"

    def initialize(roots:, argv:)
      @argv = argv
      @roots = roots
      @dsl = DSL.new
    end

    def run
      name = @argv.first
      path = name.split(":")
      manifests = @roots.map { |root| File.join(root, *path, MANIFEST) }
      manifest = manifests.find { |manifest| File.exist?(manifest) }

      if manifest.nil?
        abort "I wasn't able to find a generator named '#{name}'."
      end

      @dsl.instance_eval File.read(manifest)
      @dsl.generate.call
    end
  end

  class DSL
    attr_reader :options, :arguments, :helpers

    def initialize
      @arguments = []
      @options = []
      @helpers = []
      @parse = ->(opts){ opts }
      @generate = -> { warn "I don't know what to do!" }
    end

    def argument(name)
      @arguments << name
    end

    def option(name)
      @options << name
    end

    def parse(&block)
      @parse = block if block_given?
      @parse
    end

    def generate(&block)
      @generate = block if block_given?
      @generate
    end

    def helpers(&block)
      @helpers << Module.new(&block) if block_given?
      @helpers
    end
  end
end
