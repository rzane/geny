require "tty-file"
require "geny/context/view"

module Geny
  module Actions
    class Templates
      def initialize(root:, context:)
        @root = root
        @context = context
      end

      def copy(source, *args, **opts)
        source = expand_path(source)
        context, opts = build_context(opts)
        TTY::File.copy(source, *args, context: context, **opts)
      end

      def copy_dir(source, *args, **opts)
        source = expand_path(source)
        context, opts = build_context(opts)
        TTY::File.copy_dir(source, *args, context: context, **opts)
      end

      def render(path, **opts)
        path = expand_path(path)
        input = File.binread(path)
        context, _opts = build_context(opts)
        erb = ERB.new(input, nil, "-", "@output_buffer")
        erb.result(context.instance_eval("binding"))
      end

      private

      def expand_path(path)
        File.expand_path(path, @root)
      end

      def build_context(locals: {}, helpers: [], **opts)
        context = Context::View.new(
          locals: @context.locals.merge(locals),
          helpers: @context.helpers + helpers
        )

        [context, opts]
      end
    end
  end
end
