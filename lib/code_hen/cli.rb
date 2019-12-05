require "code_hen"
require "code_hen/parser"
require "code_hen/command"
require "code_hen/version"

module CodeHen
  class CLI
    def initialize(version: CodeHen::VERSION, load_path: CodeHen.load_path)
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
