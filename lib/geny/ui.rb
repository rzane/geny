require "pastel"

module Geny
  class UI
    def heading(message)
      say render_heading(message)
    end

    def render_heading(message)
      "#{color.dim("==")} #{color.bold(message)}"
    end

    def say(message)
      puts message
    end

    def color
      @color ||= Pastel.new(enabled: $stdout.tty?)
    end
  end
end
