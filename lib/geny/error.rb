module Geny
  Error = Class.new(StandardError)
  ParserError = Class.new(Error)
  NotFoundError = Class.new(Error)

  class ExitError < Error
    attr_reader :code, :command

    def initialize(code:, command:)
      @code = code
      @command = command
      super "Command `#{command}` failed (exit code: #{code})"
    end
  end
end
