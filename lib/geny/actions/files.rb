require "forwardable"
require "tty-file"

module Geny
  module Actions
    # Utilities for manipulating files.
    # @see https://rubydoc.info/github/piotrmurach/tty-file/master/TTY/File TTY::File
    class Files
      extend Forwardable

      def initialize(ui:)
        @ui = ui
      end

      # @!method create
      # Create a file
      # @see TTY::File.create
      #
      # @example
      #   files.create("test.txt")
      #   files.create("test.txt", "hello!")
      #   files.create("test.txt", force: true)
      def_delegator TTY::File, :create_file, :create

      # @!method copy
      # Copy a file
      # @see TTY::File.copy
      #
      # @example
      #   files.copy("foo.txt", "bar.txt")
      #   files.copy("foo.txt", "bar.txt", force: true)
      def_delegator TTY::File, :copy_file, :copy

      # @!method create_dir
      # Create a directory recursively
      # @see TTY::File.create_dir
      #
      # @example
      #   files.create_dir("app/controllers")
      def_delegator TTY::File, :create_dir

      # @!method copy_dir
      # Copy a directory recursively
      # @see TTY::File.copy_dir
      #
      # @example
      #   files.copy_dir("foo", "bar")
      #   files.copy_dir("foo", "bar", force: true)
      def_delegator TTY::File, :copy_dir

      # @!method remove
      # Remove a file
      # @see TTY::File.remove_file
      #
      # @example
      #   files.remove("test.txt")
      #   files.remove("test.txt", force: true)
      def_delegator TTY::File, :remove_file, :remove

      # @!method prepend
      # Add a line to the top of a file
      # @see TTY::File.safe_prepend_to_file
      #
      # @example
      #   files.prepend("Gemfile", "gem 'geny'")
      def_delegator TTY::File, :safe_prepend_to_file, :prepend

      # @!method append
      # Add a line to the bottom of a file
      # @see TTY::File.safe_append_to_file
      #
      # @example
      #   files.append("Gemfile", "gem 'geny'")
      def_delegator TTY::File, :safe_append_to_file, :append

      # @!method replace
      # Replace content in a file
      # @see TTY::File.replace_in_file
      #
      # @example
      #   files.replace("Gemfile", /foo/, "bar")
      def_delegator TTY::File, :replace_in_file, :replace

      # @!method insert
      # Insert content in a file before or after a matching pattern
      # @see TTY::File.safe_inject_into_file
      #
      # @example
      #   files.insert("Gemfile", "gem 'geny'", before: /gem 'rails'/)
      #   files.insert("Gemfile", "gem 'geny'", after: /gem 'rails'\n/)
      def_delegator TTY::File, :safe_inject_into_file, :insert

      # Move a file
      # @param source [String]
      # @param dest [String]
      #
      # @example
      #   files.move "Gemfile", "Gemfile.bak"
      def move(source, dest, force: false, verbose: true)
        @ui.status("move", source) if verbose
        FileUtils.mv(source, dest, force: force)
      end

      # Change directory
      # @param path [String]
      #
      # @example
      #   files.chdir "foo" do
      #     # do something inside foo/
      #   end
      def chdir(path, verbose: true, &block)
        @ui.status("cd", path) if verbose
        Dir.chdir(path, &block)
      ensure
        @ui.status("cd", "-") if verbose
      end

      # Change the permissions of a file
      # @see TTY::File.chmod
      #
      # @example
      #   files.chmod("bin/test", "+x")
      def chmod(path, mode, *args)
        TTY::File.chmod(path, coerce_mode(mode), *args)
      end

      # @see #insert
      def insert_before(path, pattern, content, **opts)
        insert(path, content, before: pattern, **opts)
      end

      # @see #insert
      def insert_after(path, pattern, content, **opts)
        insert(path, content, after: pattern, **opts)
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
