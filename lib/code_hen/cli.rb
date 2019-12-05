require "code_hen"
require "code_hen/parser"
require "code_hen/command"
require "code_hen/version"

module CodeHen
  class CLI
    LOAD_PATH = [File.expand_path("../generators", __dir__)]

    def initialize(version: CodeHen::VERSION, load_path: LOAD_PATH)
      @version = version
      @load_path = load_path
    end

    def run(argv)
      parser = Parser.new
      parser.version @version
      parser.argument :command, desc: "command to run", required: true

      options = parser.parse(argv)
      name = options[:command]
      args = options[:unused_arguments]

      command = Command.new(name: name, load_path: @load_path)
      command.run(args)
    end
  end
end
