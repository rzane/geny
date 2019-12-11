module Geny
  module Context
    class View
      attr_reader :locals

      def initialize(locals: {}, helpers: [])
        @locals = locals
        @helpers = helpers
        @helpers.each { |h| extend h }
      end

      def merge(locals: {}, helpers: [])
        View.new(
          helpers: @helpers + helpers,
          locals: self.locals.merge(locals)
        )
      end

      private

      def respond_to_missing?(meth, *)
        locals.key?(meth) || super
      end

      def method_missing(meth, *args)
        return super unless locals.key?(meth)

        unless args.empty?
          raise ArgumentError, "wrong number of arguments (given #{args.length}, expected 0)"
        end

        locals[meth]
      end
    end
  end
end
