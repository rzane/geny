require "geny/context/base"

module Geny
  module Context
    # All templates are evaluated in the context of a View.
    # All command-line options, locals, and helper methods
    # wil be available in templates.
    class View < Base
      # @private
      def merge(updates)
        View.new(command: command, locals: locals.merge(updates))
      end

      # Append to the output buffer
      def concat(data)
        @output_buffer << data
      end

      # Capture the ERB rendered inside a block
      def capture(*args, &block)
        @output_buffer, buffer_was = "", @output_buffer

        begin
          block.call(*args)
          block.binding.eval("@output_buffer")
        ensure
          @output_buffer = buffer_was
        end
      end
    end
  end
end
