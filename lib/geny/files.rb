require "tty-file"
require "forwardable"

module Geny
  class Files
    extend Forwardable

    def_delegator TTY::File, :create_file, :create
    def_delegator TTY::File, :create_dir
    def_delegator TTY::File, :remove_file, :remove
    def_delegator TTY::File, :safe_prepend_to_file, :prepend
    def_delegator TTY::File, :safe_append_to_file, :append
    def_delegator TTY::File, :replace_in_file, :replace

    def chmod(path, mode, *args)
      TTY::File.chmod(path, coerce_mode(mode), *args)
    end

    def insert_before(path, pattern, content, **opts)
      opts = {before: pattern, **opts}
      TTY::File.safe_inject_into_file(path, content, opts)
    end

    def insert_after(path, pattern, content, **opts)
      opts = {after: pattern, **opts}
      TTY::File.safe_inject_into_file(path, content, opts)
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
