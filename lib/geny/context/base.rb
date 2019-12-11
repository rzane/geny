module Geny
  module Context
    class Base
      attr_reader :locals, :_helpers

      def initialize(locals: {}, helpers: [])
        @locals = locals
        @_helpers = helpers
        @_helpers.each { |h| extend h }
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
