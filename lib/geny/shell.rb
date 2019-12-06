require "open3"

module Geny
  class Shell
    def initialize(ui:, output:)
      @ui = ui
      @output = output
    end

    def capture(*args)
      cmd = build(*args)
      out, _err, status = Open3.capture3(*cmd)
      out.chomp if status.success?
    rescue Errno::ENOENT
    end

    def run(*args, verbose: true, **opts)
      cmd = build(*args, **opts)
      cmd_str = stringify(args)

      @ui.status("run", cmd_str) if verbose

      return if Kernel.system(*cmd)
      error!(cmd_str, $?.exitcode)
    end

    private

    def build(*args, env: nil, chdir: ".", **opts)
      [*env, *args, chdir: expand_path(chdir), **opts]
    end

    def expand_path(path)
      File.expand_path(path, @output)
    end

    def stringify(args)
      args.map { |arg| arg.match?(/\s/) ? arg.inspect : arg }.join(" ")
    end

    def error!(cmd, code)
      raise ExitStatusError, "Command `#{cmd}` failed (exit code: #{code})"
    end
  end
end
