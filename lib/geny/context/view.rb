require "geny/context/base"

module Geny
  module Context
    class View < Base
      def merge(updates)
        View.new(command: command, locals: locals.merge(updates))
      end
    end
  end
end
