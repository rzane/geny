require "forwardable"

module Geny
  module Context
    class Base
      extend Forwardable

      attr_reader :locals, :helpers

      def self.delegate_all(klass, to:, prefix: nil)
        names = klass.instance_methods - Object.instance_methods
        names.each do |name|
          def_delegator(to, name, prefix ? "#{prefix}_#{name}" : name)
        end
      end

      def initialize(locals: {}, helpers: [])
        @locals = locals
        @helpers = helpers
        @helpers.each { |h| extend h }
      end

      private

      def respond_to_missing?(name, *)
        locals.key?(name) || super
      end

      def method_missing(name, *args)
        return super unless locals.key?(name)

        unless args.empty?
          raise ArgumentError, "wrong number of arguments (given #{args.length}, expected 0)"
        end

        locals[name]
      end
    end
  end
end
