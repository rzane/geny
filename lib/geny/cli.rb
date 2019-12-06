require "argy"
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
      name, args = parse(argv)

      if name.nil?
        show_all_commands
      else
        command = registry.find!(name)
        command.run(args)
      end
    end

    private

    def show_all_commands
      ui.heading("Generators")

      registry.scan.each do |command|
        name = ui.color.cyan(command.name)
        desc = command.description&.rjust(38)
        desc = ui.color.dim(desc) if desc
        ui.say "#{name}#{desc}"
      end
    end

    def parse(argv)
      options = Argy.parse argv do |o|
        o.version version
        o.argument :command, desc: "command to run"
      end

      options.values_at(:command, :unused_arguments)
    end

    def ui
      @ui ||= UI.new
    end
  end
end
