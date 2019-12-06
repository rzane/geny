require "tty-file"

module Geny
  class Files
    def initialize(output:)
      @output = output
    end

    def create(path, *args)
      TTY::File.create_file(resolve(path), *args)
    end

    def create_dir(path, *args)
      TTY::File.create_dir(resolve(path), *args)
    end

    def remove(path, *args)
      TTY::File.remove_file(resolve(path), *args)
    end

    def chmod(path, mode, *args)
      TTY::File.chmod(resolve(path), coerce_mode(mode), *args)
    end

    def prepend(path, *args)
      TTY::File.safe_prepend_to_file(resolve(path), *args)
    end

    def append(path, *args)
      TTY::File.safe_append_to_file(resolve(path), *args)
    end

    def replace(path, *args)
      TTY::File.replace_in_file(resolve(path), *args)
    end

    def insert_before(path, pattern, content, **opts)
      opts = {before: pattern, **opts}
      TTY::File.safe_inject_into_file(resolve(path), content, opts)
    end

    def insert_after(path, pattern, content, **opts)
      opts = {after: pattern, **opts}
      TTY::File.safe_inject_into_file(resolve(path), content, opts)
    end

    private

    def resolve(path)
      path = Pathname.new(path).expand_path(@output)
      path.relative_path_from(Pathname.pwd).to_s
    end

    def coerce_mode(mode)
      if mode.respond_to?(:match?) && mode.match?(/^[+-]/)
        "a#{mode}"
      else
        mode
      end
    end
  end
end
