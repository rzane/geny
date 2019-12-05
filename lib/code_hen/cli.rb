require "code_hen"
require "code_hen/ui"
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
      parser.argument :command, desc: "command to run"

      options = parser.parse(argv)
      name = options[:command]
      args = options[:unused_arguments]

      if name.nil?
        show_all_commands
      else
        command = Command.new(name: name, load_path: @load_path)
        command.run(args)
      end
    end

    private

    def show_all_commands
      commands = Command.scan(load_path: @load_path)

      ui.heading("Generators")

      commands.each do |command|
        name = ui.color.cyan(command.name)
        desc = command.description&.rjust(38)
        desc = ui.color.dim(desc) if desc
        ui.say "#{name}#{desc}"
      end
    end

    def ui
      @ui ||= UI.new
    end
  end
end
