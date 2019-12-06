require "geny"
require "geny/ui"
require "geny/registry"
require "geny/version"

module Geny
  class CLI
    attr_reader :version, :registry

    def initialize(version: VERSION, registry: Registry.new)
      @version = version
      @registry = registry
    end

    def run(argv)
      name, *args = argv

      case name
      when nil, '-h', '--help'
        print_help
      when '-v', '--version'
        ui.say version
      else
        command = registry.find!(name)
        command.run(args)
      end
    end

    private

    def print_help
      ui.say ui.color.bold("USAGE")
      ui.say "  geny [COMMAND]"
      ui.say ui.color.bold("\nARGUMENTS")
      ui.say "  COMMAND              command to run (required)"
      ui.say ui.color.bold("\nFLAGS")
      ui.say "  -v, --version        print version and exit"
      ui.say "  -h, --help           show this help and exit"
      ui.say ui.color.bold("\nCOMMANDS")
      registry.scan.each do |command|
        ui.say "  #{command.name}#{command.description&.rjust(40)}"
      end
    end

    def ui
      @ui ||= UI.new
    end
  end
end
