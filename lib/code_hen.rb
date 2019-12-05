require "code_hen/version"

module CodeHen
  class Error < StandardError; end

  class CLI
    def initialize(argv: ARGV)
      @argv = ARGV
    end

    def run
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
