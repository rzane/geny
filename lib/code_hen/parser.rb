require "optparse"
require "code_hen/option"

module CodeHen
  class Parser
    class Error < StandardError
    end

    def initialize
      @usage = $0
      @description = nil
      @arguments = []
      @options = []
      @examples = []
    end

    def usage(usage)
      @usage = usage
    end

    def description(description)
      @description = description
    end

    def example(example)
      @examples << example
    end

    def argument(*args)
      @arguments << Option.new(*args)
    end

    def option(*args)
      @options << Option.new(*args)
    end

    def to_s
      build_parser(values: {}).to_s
    end

    def parse(argv)
      argv = argv.dup
      values = collect_default_values
      parser = build_parser(values: values)
      parser.order!(argv)
      backfill_arguments(argv: argv, values: values)
      validate!(values: values)
      values
    end

    private

    def backfill_arguments(values:, argv:)
      argv.zip(@arguments).each do |value, arg|
        if arg.nil?
          values[:unused_arguments] << value
        else
          values[arg.name] = arg.coerce(value)
        end
      end
    end

    def collect_default_values
      (@arguments + @options).reduce(unused_arguments: []) do |acc, opt|
        acc[opt.name] = opt.default
        acc
      end
    end

    def build_parser(values:)
      OptionParser.new "Usage:\n    #{@usage}" do |parser|
        unless @description.nil?
          parser.separator "\nDescription:\n    #{@description}"
        end

        unless @examples.empty?
          parser.separator "\nExamples:"
          @examples.each do |example|
            parser.separator "    #{example}"
          end
        end

        unless @arguments.empty?
          parser.separator "\nArguments:"
          @arguments.each do |arg|
            parser.separator "    #{arg.label}#{arg.desc.rjust(39)}"
          end
        end

        unless @options.empty?
          parser.separator "\nOptions:"
          @options.each do |opt|
            parser.on(*opt.parser_options) do |value|
              values[opt.name] = opt.coerce(value)
            end
          end
        end

        parser.on_tail("-h", "--help") do
          puts parser
          exit
        end
      end
    end

    def validate!(values:)
      args = detect_missing_options(values, @arguments).map(&:label)
      opts = detect_missing_options(values, @options).map(&:flag)

      unless args.empty?
        raise Error, "Missing required arguments: #{args.join(", ")}"
      end

      unless opts.empty?
        raise Error, "Missing required options: #{opts.join(", ")}"
      end
    end

    def detect_missing_options(values, options)
      options.select { |o| o.required? && values[o.name].nil? }
    end
  end
end
