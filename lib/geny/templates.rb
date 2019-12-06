require "tty-file"

module Geny
  class Templates
    def initialize(root:)
      @root = root
    end

    def copy(*args)
      delegate(:copy_file, *args)
    end

    def copy_dir(*args)
      delegate(:copy_dir, *args)
    end

    private

    attr_reader :root

    def delegate(action, source, dest, **opts)
      source = File.expand_path(source, root)
      TTY::File.send(action, source, dest, **opts)
    end
  end
end
