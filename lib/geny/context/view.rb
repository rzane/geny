require "geny/context/base"

module Geny
  module Context
    class View < Base
      def merge(locals: {}, helpers: [])
        View.new(
          helpers: self._helpers + helpers,
          locals: self.locals.merge(locals)
        )
      end
    end
  end
end
