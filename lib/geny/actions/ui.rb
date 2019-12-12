require "tty-prompt"

module Geny
  module Actions
    class UI < TTY::Prompt
      attr_reader :color

      def initialize(color:, **opts)
        super(opts)
        @color = color
      end

      def heading(message)
        say "#{@color.dim("==")} #{@color.bold(message)}"
      end

      def status(label, message, color: :green)
        say "#{@color.send(color, label.rjust(12))}  #{message}"
      end

      def error(message)
        stderr.puts "#{@color.red("ERROR:")} #{message}"
      end

      def abort!(message)
        error(message)
        exit 1
      end
    end
  end
end
