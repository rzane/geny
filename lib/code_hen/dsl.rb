module CodeHen
  class DSL
    def initialize
      @helpers = []
      @parse = ->(opts){ opts }
      @invoke = -> { warn "I don't know what to do!" }
    end

    def parse(&block)
      @parse = block if block_given?
      @parse
    end

    def invoke(&block)
      @invoke = block if block_given?
      @invoke
    end

    def helpers(&block)
      @helpers << Module.new(&block) if block_given?
      @helpers
    end
  end
end
