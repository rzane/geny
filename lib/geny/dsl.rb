require "argy"
require "pathname"

module Geny
  # The top-level command file is evaulated in the context
  # of this class.
  class DSL
    # @private
    def initialize
      @helpers = []
      @invoke = proc { warn "I don't know what to do!" }
    end

    # Define arguments and options that the command accepts.
    # The block is evaluated in the context of an {https://rubydoc.info/github/rzane/argy/Argy/Parser Argy::Parser}.
    def parse(&block)
      parser.instance_eval(&block)
    end

    # Define the behavior for when the command runs. The block is
    # evaluated in the context of a {Context::Invoke}.
    def invoke(&block)
      @invoke = block if block_given?
      @invoke
    end

    # Define helper methods. These methods are available within
    # the {#invoke} block and all templates.
    def helpers(&block)
      @helpers << Module.new(&block) if block_given?
      @helpers
    end

    # @private
    def parser
      @parser ||= Argy.new do |o|
        o.on "-h", "--help", "show this help and exit" do
          puts o.help
          exit
        end
      end
    end
  end
end
