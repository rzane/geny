require "find"
require "fileutils"
require "tty-file"

module Geny
  module Actions
    class Find
      # Replace the content of any file that matches the pattern with
      # a replacement
      # @param root [String] the path to search
      # @param pattern [String,Regexp] a pattern to find
      # @param replacement [String] the content to insert
      # @param force [TrueClass,FalseClass] overwrite existing files
      # @param excluding [Regexp] exclude any file matching this pattern
      #
      # @example
      #   find.and_replace("src", "Boilerplate", "YourProject")
      def and_replace(root, pattern, replacement, force: false, excluding: nil)
        ::Find.find(root) do |path|
          next if path == root
          next if File.directory?(path)
          next if TTY::File.binary?(path)
          next if excluding && path.match?(excluding)

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
      #   find.and_rename("src", "Boilerplate", "YourProject")
      def and_rename(root, pattern, replacement, force: false, excluding: nil)
        loop do
          done = true

          ::Find.find(root) do |path|
            next if path == root
            next unless path.match?(pattern)
            next if excluding && path.match?(excluding)

            # Rename the file or directory
            dest = path.sub(pattern, replacement)
            FileUtils.mv(path, dest, force: force)

            # We need to rescan the files, because this
            # might be a directory and it might contain
            # matching files
            done = false

            # We have a match, do not attept to search
            # the children of this path.
            ::Find.prune
          end

          break if done
        end
      end
    end
  end
end
