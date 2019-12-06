require "geny/error"

module Geny
  class Git
    def initialize(shell:)
      @shell = shell
    end

    def init(*args)
      @shell.run("git", "init", *args, out: File::NULL)
    end

    def add(*args)
      @shell.run("git", "add", *args, out: File::NULL)
    end

    def commit(message, *args)
      @shell.run("git", "commit", "-m", message, *args, out: File::NULL)
    end

    def root
      @shell.capture("git", "rev-parse", "--show-toplevel", **args)
    end
  end
end
