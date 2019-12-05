module CodeHen
  class Context
    def initialize(locals)
      @locals = locals
    end

    private

    def respond_to_missing?(name, *)
      @locals.key?(name) || super
    end

    def method_missing(name, *args)
      return super unless @locals.key?(name)

      unless args.empty?
        raise ArgumentError, "wrong number of arguments (given #{args.length}, expected 0)"
      end

      @locals[name]
    end
  end
end
