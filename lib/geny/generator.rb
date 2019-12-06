require "geny/ui"
require "geny/files"

module Geny
  class Generator
    def initialize(context:)
      @context = context
    end

    def ui
      @ui ||= UI.new
    end

    def files
      @files ||= Files.new(@context.fetch(:output))
    end

    private

    def respond_to_missing?(name, *)
      @context.key?(name) || super
    end

    def method_missing(name, *args)
      return super unless @context.key?(name)

      unless args.empty?
        raise ArgumentError, "wrong number of arguments (given #{args.length}, expected 0)"
      end

      @context[name]
    end
  end
end
