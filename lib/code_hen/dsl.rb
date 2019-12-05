module CodeHen
  class DSL
    def initialize
      @helpers = []
      @parse = ->(opts){ opts }
      @generate = -> { warn "I don't know what to do!" }
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
