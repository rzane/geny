require "argy"
require "pathname"

module Geny
  class DSL
    def initialize
      @helpers = []
      @invoke = proc { warn "I don't know what to do!" }
    end

    def parser
      @parser ||= Argy.new
    end

    def parse(&block)
      parser.instance_eval(&block)
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
