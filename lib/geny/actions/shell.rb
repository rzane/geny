require "open3"
require "geny/error"

module Geny
  module Actions
    class Shell
      def initialize(ui:)
        @ui = ui
      end

      def capture(*args, **opts)
        cmd = build_command(*args, **opts)
        cmd_str = stringify_command(args)
        out, _err, status = Open3.capture3(*cmd)
        assert_success!(status, cmd_str)
        out.chomp
      rescue Errno::ENOENT
        raise ExitError.new(command: cmd_str, code: 127)
      end

      def run(*args, verbose: true, **opts)
        cmd = build_command(*args, **opts)
        cmd_str = stringify_command(args)

        @ui.status("run", cmd_str) if verbose

        Kernel.system(*cmd)
        assert_success!($?, cmd_str)
      end

      private

      def build_command(*args, env: nil, **opts)
        [*env, *args, **opts]
      end

      def stringify_command(args)
        args.map { |arg| arg.match?(/\s/) ? arg.inspect : arg }.join(" ")
      end

      def assert_success!(status, cmd)
        unless status.success?
          raise ExitError.new(command: cmd, code: status.exitstatus)
        end
      end
    end
  end
end
