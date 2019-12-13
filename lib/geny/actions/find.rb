require "find"
require "fileutils"
require "tty-file"

module Geny
  module Actions
    # Utilities for manipulating files in bulk
    class Find
      # Replace the content of any file that matches the pattern with
      # a replacement
      # @param root [String] the path to search
      # @param pattern [String,Regexp] a pattern to find
      # @param replacement [String] the content to insert
      # @param force [TrueClass,FalseClass] overwrite existing files
      # @param excluding [Regexp] exclude any file matching this pattern
      # @note This attempts to ignore binary files
      #
      # @example
      #   find.replace("src", "Boilerplate", "YourProject")
      def replace(root, pattern, replacement, force: false, excluding: nil)
        ::Find.find(root)
          .lazy
          .reject { |path| path == root }
          .reject { |path| excluding && path.match?(excluding) }
          .reject { |path| File.directory?(path) }
          .reject { |path| TTY::File.binary?(path) }
          .each do |path|
            TTY::File.replace_in_file(
              path,
              pattern,
              replacement,
              verbose: false,
              force: force
            )
          end
      end

      # Replace any filename that matches the pattern with a replacement
      # @param root [String] the path to search
      # @param pattern [String,Regexp] a pattern to find
      # @param replacement [String] the content to insert
      # @param force [TrueClass,FalseClass] overwrite existing files
      # @param excluding [Regexp] exclude any file matching this pattern
      #
      # @example
      #   find.rename("src", "Boilerplate", "YourProject")
      def rename(root, pattern, replacement, force: false, excluding: nil)
        ::Find.find(root)
          .lazy
          .reject { |path| path == root }
          .reject { |path| excluding && path.match?(excluding) }
          .select { |path| path.match?(pattern) }
          .sort { |path| depth(path) }
          .map { |path| [path, rsub(path, pattern, replacement)] }
          .each { |source, dest| FileUtils.mv(source, dest) }
      end

      private

      # Replace the last match of a string
      def rsub(str, pattern, replacement)
        prefix, match, suffix = str.rpartition(pattern)
        return str if prefix.empty? and match.empty?
        "#{prefix}#{replacement}#{suffix}"
      end

      # Get the depth of a path
      def depth(path)
        path.split(File::SEPARATOR).length
      end
    end
  end
end
