require "forwardable"
require "tty-file"

module Geny
  module Actions
    # Utilities for manipulating files.
    # @see https://rubydoc.info/github/piotrmurach/tty-file/master/TTY/File TTY::File
    class Files
      extend Forwardable

      # @!method create
      # Create a file
      #
      # @example
      #   files.create("test.txt")
      #   files.create("test.txt", "hello!")
      #   files.remove("test.txt", force: true)
      def_delegator TTY::File, :create_file, :create

      # @!method create_dir
      # Create a directory recursively
      #
      # @example
      #   files.create_dir("app/controllers")
      def_delegator TTY::File, :create_dir

      # @!method remove
      # Remove a file
      #
      # @example
      #   files.remove("test.txt")
      #   files.remove("test.txt", force: true)
      def_delegator TTY::File, :remove_file, :remove

      # @!method prepend
      # Add a line to the top of a file
      #
      # @example
      #   files.prepend("Gemfile", "gem 'geny'")
      def_delegator TTY::File, :safe_prepend_to_file, :prepend

      # @!method append
      # Add a line to the bottom of a file
      #
      # @example
      #   files.append("Gemfile", "gem 'geny'")
      def_delegator TTY::File, :safe_append_to_file, :append

      # @!method replace
      # Replace content in a file
      #
      # @example
      #   files.replace("Gemfile", /foo/, "bar")
      def_delegator TTY::File, :replace_in_file, :replace

      # @!method insert
      # Insert content in a file before or after a matching pattern
      #
      # @example
      #   files.insert("Gemfile", "gem 'geny'", before: /gem 'rails'/)
      #   files.insert("Gemfile", "gem 'geny'", after: /gem 'rails'\n/)
      def_delegator TTY::File, :safe_inject_into_file, :insert

      # Change the permissions of a file
      #
      # @example
      #   files.chmod("bin/test", "+x")
      def chmod(path, mode, *args)
        TTY::File.chmod(path, coerce_mode(mode), *args)
      end

      private

      def coerce_mode(mode)
        if mode.respond_to?(:match?) && mode.match?(/^[+-]/)
          "a#{mode}"
        else
          mode
        end
      end
    end
  end
end
