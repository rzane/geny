module CodeHen
  class Option
    attr_reader :name, :type, :aliases, :desc, :default

    def initialize(name, aliases: [], desc: "", type: :string, default: nil, required: false)
      @name = name
      @type = type
      @aliases = aliases
      @desc = desc
      @default = default
      @required = required
    end

    def required?
      @required
    end

    def flag
      "--#{name.to_s.tr("_", "-")}"
    end

    def label
      name.to_s.upcase
    end

    def coerce(value)
      case type
      when :string, :boolean then value
      when :integer then Integer(value)
      when :float then Float(value)
      when :array then value.split(",")
      else
        if type.respond_to?(:call)
          type.call(value)
        else
          raise "Invalid type: #{type}"
        end
      end
    rescue ArgumentError
      raise ParserError, "#{value.inspect} could not be coerced to a #{type}."
    end

    def parser_options
      label = name.to_s.upcase

      options = []
      options << aliases.join(" ") unless aliases.empty?

      if type == :boolean
        options << flag.sub(/^--/, "--[no-]")
      else
        options << "#{flag}=#{label}"
        options << "#{flag} #{label}"
      end

      options << desc
      options
    end
  end
end
