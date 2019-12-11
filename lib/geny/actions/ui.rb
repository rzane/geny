require "pastel"

module Geny
  module Actions
    class UI
      attr_reader :color

      def initialize(color:)
        @color = color
      end

      def heading(message)
        say "#{@color.dim("==")} #{@color.bold(message)}"
      end

      def status(label, message, color: :green)
        say "#{@color.send(color, label.rjust(12))}  #{message}"
      end

      def say(message)
        puts message
      end
    end
  end
end
