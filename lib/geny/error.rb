module Geny
  # A base class for all errors
  class Error < StandardError
  end

  # Raised when a command cannot be found.
  class NotFoundError < Error
  end

  # Raised when a shell command exits with a non-zero status.
  class ExitError < Error
    attr_reader :code, :command

    def initialize(code:, command:)
      @code = code
      @command = command
      super "Command `#{command}` failed (exit code: #{code})"
    end
  end
end
