require "argy"
require "geny"
require "geny/registry"
require "geny/version"
require "geny/actions/ui"

module Geny
  class CLI
    attr_reader :registry, :version, :program_name, :description, :column

    def initialize(
      registry: Registry.new,
      version: VERSION,
      program_name: "geny",
      description: nil,
      column: 20
    )
      @registry = registry
      @version = version
      @program_name = program_name
      @description = description
      @column = column
    end

    def run(argv)
      command_name, *command_args = argv

      case command_name
      when nil, '-h', '--help'
        print_help
      when '-v', '--version'
        ui.say version
      else
        command = registry.find!(command_name)
        command.run(command_args)
      end
    end

    def abort!(message)
      ui.abort!(message)
    end

    private

    def print_help
      parser = Argy.new do |o|
        o.usage("#{program_name} [COMMAND]")
        o.description(description)
        o.argument :command, desc: "generator to run", required: true
        o.on "-v", "--version", "print version and exit"
      end

      ui.say parser.help(column: column)
      ui.say color.bold("\nCOMMANDS")

      registry.scan.each do |cmd|
        desc = color.dim(cmd.description || "")
        ui.say "  #{cmd.name.ljust(column)}#{desc}"
      end
    end

    def ui
      Actions::UI.new(color: color)
    end

    def color
      Pastel.new(enabled: $stdout.tty?)
    end
  end
end
