require "tty-prompt"

module Geny
  module Actions
    # Utillities for printing to the console.
    # @see https://rubydoc.info/github/piotrmurach/tty-prompt/TTY/Prompt TTY::Prompt
    class UI < TTY::Prompt
      attr_reader :color

      # Create a new UI
      # @param color [Pastel]
      def initialize(color:, **opts)
        super(opts)
        @color = color
      end

      # Print a heading
      # @param message [String]
      #
      # @example
      #   ui.heading "Files"
      def heading(message)
        say "#{@color.dim("==")} #{@color.bold(message)}"
      end

      # Print a status
      # @param label [String]
      # @param message [String]
      # @param color [Symbol]
      #
      # @example
      #   ui.status "create", "hello.txt"
      #   ui.status "remove", "hello.txt", color: :red
      def status(label, message, color: :green)
        say "#{@color.send(color, label.rjust(12))}  #{message}"
      end

      # Print an error
      # @param message [String]
      #
      # @example
      #   ui.error "the world is ending"
      def error(message)
        stderr.puts "#{@color.red("ERROR:")} #{message}"
      end

      # Print and error and abort
      # @param message [String]
      # @raise [SystemExit]
      #
      # @example
      #   ui.abort! "command failed, exiting"
      def abort!(message)
        error(message)
        exit 1
      end
    end
  end
end
