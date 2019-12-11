require "pastel"

module Geny
  module Actions
    class UI
      def color
        @color ||= Pastel.new(enabled: $stdout.tty?)
      end

      def heading(message)
        say "#{color.dim("==")} #{color.bold(message)}"
      end

      def status(label, message, color: :green)
        say "#{self.color.send(color, label.rjust(12))}  #{message}"
      end

      def say(message)
        puts message
      end
    end
  end
end
