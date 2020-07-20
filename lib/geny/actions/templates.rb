require "tty-file"
require "geny/context/view"

module Geny
  module Actions
    # Utilities for rendering and copying templates.
    # @see https://rubydoc.info/github/piotrmurach/tty-file/master/TTY/File TTY::File
    class Templates
      # Creates a new instance
      # @param root [String] the root path where templates live
      # @param view [View] a view that exposes locals and helpers
      def initialize(root:, view:)
        @root = root
        @view = view
      end

      # Copy a template file. The file will be evaluated with ERB.
      # All command-line options and helper methods are available in
      # the template.
      #
      # @example
      #   templates.copy("hello.erb", "hello.txt")
      #   templates.copy("hello.erb", "hello.txt", locals: {name: "world"})
      def copy(source, *args, **opts)
        source = expand_path(source)
        context, opts = build_context(**opts)
        TTY::File.copy_file(source, *args, context: context, **opts)
      end

      # Copy a template directory. All files will be evaluated with ERB.
      # All command-line options and helper methods are available in
      # the template.
      #
      # @example
      #   templates.copy_dir("boilerplate", output)
      #   templates.copy_dir("boilerplate", output, locals: {name: "world"})
      def copy_dir(source, *args, **opts)
        source = expand_path(source)
        context, opts = build_context(**opts)
        TTY::File.copy_dir(source, *args, context: context, **opts)
      end

      # Render an ERB template. All command-line options and helper
      # methods are available in the template.
      #
      # @example
      #   templates.render("hello.erb")
      #   templates.render("hello.erb", locals: {name: "world"})
      def render(path, **opts)
        path = expand_path(path)
        input = File.binread(path)
        context, _opts = build_context(**opts)
        erb = ERB.new(input, nil, "-", "@output_buffer")
        erb.result(context.instance_eval("binding"))
      end

      private

      def build_context(locals: {}, **opts)
        [@view.merge(locals), opts]
      end

      def expand_path(path)
        File.expand_path(path, @root)
      end
    end
  end
end
