require "argy"
require "geny"
require "geny/ui"
require "geny/registry"
require "geny/version"

module Geny
  class CLI
    attr_reader :registry, :version, :program_name, :description

    def initialize(
      registry: Registry.new,
      version: VERSION,
      program_name: "geny",
      description: nil
    )
      @registry = registry
      @version = version
      @program_name = program_name
      @description = description
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

    private

    def print_help
      parser = Argy.new do |o|
        o.usage("#{program_name} [COMMAND]")
        o.description(description)
        o.argument :command, desc: "generator to run", required: true
        o.on "-v", "--version", "print version and exit"
      end

      ui.say parser.help(column: 20)
      ui.say ui.color.bold("\nCOMMANDS")

      registry.scan.each do |cmd|
        desc = ui.color.dim(cmd.description || "")
        ui.say "  #{cmd.name.ljust(20)}#{desc}"
      end
    end

    def ui
      @ui ||= UI.new
    end
  end
end
