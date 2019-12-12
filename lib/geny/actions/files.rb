require "tty-file"

module Geny
  module Actions
    # Utilities for manipulating files.
    # @see https://rubydoc.info/github/piotrmurach/tty-file/master/TTY/File TTY::File
    class Files
      # Create a file
      #
      # @example
      #   files.create("test.txt")
      #   files.create("test.txt", "hello!")
      #   files.remove("test.txt", force: true)
      def create(*args)
        TTY::File.create_file(*args)
      end

      # Create a directory recursively
      #
      # @example
      #   files.create_dir("app/controllers")
      def create_dir(*args)
        TTY::File.create_dir(*args)
      end

      # Remove a file
      #
      # @example
      #   files.remove("tmp")
      #   files.remove("tmp", force: true)
      def remove(*args)
        TTY::File.remove_file(*args)
      end

      # Add a line to the top of a file
      #
      # @example
      #   files.prepend("Gemfile", "gem 'geny'")
      def prepend(*args)
        TTY::File.safe_prepend_to_file(*args)
      end

      # Add a line to the bottom of a file
      #
      # @example
      #   files.append("Gemfile", "gem 'geny'")
      def append(*args)
        TTY::File.safe_append_to_file(*args)
      end

      # Replace content in a file
      #
      # @example
      #   files.replace("Gemfile", /foo/, "bar")
      def replace(*args)
        TTY::File.replace_in_file(*args)
      end

      # Insert a line before a matching line in a file
      #
      # @example
      #   files.insert_before("Gemfile", /gem "rails"/, "gem 'geny'")
      def insert_before(path, pattern, content, **opts)
        opts = {before: pattern, **opts}
        TTY::File.safe_inject_into_file(path, content, opts)
      end

      # Insert a line after a matching line in a file
      #
      # @example
      #   files.insert_after("Gemfile", /gem "rails"\n/, "gem 'geny'")
      def insert_after(path, pattern, content, **opts)
        opts = {after: pattern, **opts}
        TTY::File.safe_inject_into_file(path, content, opts)
      end

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
