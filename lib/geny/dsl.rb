require "pathname"
require "geny/parser"

module Geny
  class DSL
    def initialize
      @helpers = []
      @invoke = proc { warn "I don't know what to do!" }
    end

    def parser
      @parser ||= Parser.new do |o|
        o.option :output, aliases: ["-o"], type: :pathname, default: Pathname.pwd
      end
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
