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
    end
  end
end
