require "geny/error"

module Geny
  module Actions
    # Utilities for interacting with a git repo
    class Git
      # Create a new Git
      # @param shell [Shell]
      def initialize(shell:)
        @shell = shell
      end

      # Initialize a new git repo
      # @raise [ExitError]
      #
      # @example
      #   git.init
      def init(**opts)
        @shell.run("git", "init", out: File::NULL, **opts)
      end

      # Stage files to be committed
      # @param files [Array<String>]
      # @raise [ExitError]
      #
      # @example
      #   git.add
      #   git.add files: ["Gemfile"]
      def add(files: ["."], **opts)
        @shell.run("git", "add", *files, out: File::NULL, **opts)
      end

      # Commit staged files
      # @param message [String]
      # @raise [ExitError]
      #
      # @example
      #   git.commit message: "First commit"
      def commit(message:, **opts)
        @shell.run("git", "commit", "-m", message, out: File::NULL, **opts)
      end

      # Get the path to the current git repo
      # @raise [ExitError]
      #
      # @example
      #   git.repo_path #=> "/path/to/repo"
      def repo_path(**opts)
        @shell.capture("git", "rev-parse", "--show-toplevel", **opts)
      end
    end
  end
end
