require "geny/error"

module Geny
  module Actions
    class Git
      def initialize(shell:)
        @shell = shell
      end

      def init(**opts)
        @shell.run("git", "init", out: File::NULL, **opts)
      end

      def add(files: ["."], **opts)
        @shell.run("git", "add", *files, out: File::NULL, **opts)
      end

      def commit(message:, **opts)
        @shell.run("git", "commit", "-m", message, out: File::NULL, **opts)
      end

      def repo_path(**opts)
        @shell.capture("git", "rev-parse", "--show-toplevel", **opts)
      end
    end
  end
end
