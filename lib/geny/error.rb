module Geny
  Error = Class.new(StandardError)
  ParserError = Class.new(Error)
  NotFoundError = Class.new(Error)
  ExitStatusError = Class.new(Error)
end
