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
        ::Find.find(root) do |path|
          # The first emitted path will be the root directory
          next if path == root

          # Don't look any further into this directory
          ::Find.prune if excluding && excluding.match?(excluding)

          # We don't care about directories
          next if File.directory?(path)

          # We can't replace binary files
          next if TTY::File.binary?(path)

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
        matches = []
        options = {force: force, excluding: nil}

        ::Find.find(root) do |path|
          # The first emitted path will be the root directory
          next if path == root

          # Don't look any further into this directory
          ::Find.prune if excluding && excluding.match?(excluding)

          # The path doesn't match, keep searching
          next unless path.match?(pattern)

          # Record the match
          matches << path

          # Don't search the children of the match, because it will
          # be renamed. We'll have re-run against the renamed path
          ::Find.prune
        end

        matches.each do |source|
          dest = source.sub(pattern, replacement)
          FileUtils.mv(source, dest, force: force)
          rename(dest, pattern, replacement, options) if File.directory?(dest)
        end
      end
    end
  end
end
