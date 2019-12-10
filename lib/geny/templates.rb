require "tty-file"

module Geny
  class Templates
    def initialize(root:, locals: {}, helpers: [])
      @root = root
      @locals = locals
      @helpers = helpers
    end

    def copy(*args)
      delegate(:copy_file, *args)
    end

    def copy_dir(*args)
      delegate(:copy_dir, *args)
    end

    def render(path, locals: {}, helpers: [])
      path = File.expand_path(path, root)
      input = File.binread(path)

      context = Context.new(
        locals: @locals.merge(locals),
        helpers: @helpers + helpers
      )

      erb = ERB.new(input, nil, "-", "@output_buffer")
      erb.result(context.instance_eval("binding"))
    end

    private

    attr_reader :root

    def delegate(action, source, dest, **opts)
      source = File.expand_path(source, root)
      TTY::File.send(action, source, dest, **opts)
    end

    class Context
      attr_reader :locals

      def initialize(locals: {}, helpers: [])
        @locals = locals
        helpers.each { |helper| extend helper }
      end

      private

      def respond_to_missing?(name, *)
        locals.key?(name) || super
      end

      def method_missing(name, *args)
        return super unless locals.key?(name)

        unless args.empty?
          raise ArgumentError, "wrong number of arguments (given #{args.length}, expected 0)"
        end

        locals[name]
      end
    end
  end
end
