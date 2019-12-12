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
      opts = parser.parse(argv, strategy: :order)
      help! unless opts.command?

      command = registry.find!(opts.command)
      command.run(opts.unused_args)
    end

    def abort!(message)
      color = Pastel.new(enabled: $stdout.tty?)
      ui = Actions::UI.new(color: color)
      ui.abort!(message)
    end

    private

    def parser
      @parser ||= Argy.new do |o|
        o.usage "#{program_name} [COMMAND]"
        o.description description
        o.argument :command, desc: "generator to run"

        o.on "-v", "--version", "print version and exit" do
          puts version
          exit
        end

        o.on "-h", "--help", "show this help and exit" do
          help!
        end
      end
    end

    def help!
      help = parser.help(column: column)
      puts help
      puts help.section("COMMANDS")

      registry.scan.each do |cmd|
        puts help.entry(cmd.name, desc: cmd.description)
      end

      exit
    end
  end
end
