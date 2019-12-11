require "tty-file"
require "geny/context/view"

module Geny
  module Actions
    class Templates
      def initialize(root:, view:)
        @root = root
        @view = view
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

      def build_context(locals: {}, helpers: [], **opts)
        [@view.merge(locals: locals, helpers: helpers), opts]
      end

      def expand_path(path)
        File.expand_path(path, @root)
      end
    end
  end
end
