require "pathname"
require "geny/error"
require "geny/command"

module Geny
  class Registry
    # The default load path. By default, Geny
    # will search
    LOAD_PATH = [
      File.join(Dir.pwd, ".geny"),
      *ENV.fetch("GENY_PATH", "").split(Command::SEPARATOR),
      File.join(__dir__, "generators")
    ]

    # The directories to search for commands in
    # @return [Array<String>]
    attr_reader :load_path

    # Create a new registry
    # @param load_path [Array<String>]
    def initialize(load_path: LOAD_PATH)
      @load_path = load_path
    end

    # Iterate over all load paths and find all commands
    # @return [Array<Command>]
    def scan
      glob = File.join("**", Command::FILENAME)

      commands = load_path.flat_map do |path|
        path = Pathname.new(path)

        path.glob(glob).map do |file|
          root = file.dirname
          name = root.relative_path_from(path)
          name = name.to_s.tr(File::SEPARATOR, Command::SEPARATOR)
          build(name, root.to_s)
        end
      end

      commands.sort_by(&:name)
    end

    # Find a command by name
    # @param name [String] name of the command
    # @return [Command,nil]
    def find(name)
      load_path.each do |path|
        parts = name.split(Command::SEPARATOR)
        file = File.join(path, *parts, Command::FILENAME)
        root = File.dirname(file)
        return build(name, root) if File.exist?(file)
      end

      nil
    end

    # Find a command by name or raise an error
    # @param name [String] name of the command
    # @raise [NotFoundError] when the command is not found
    # @return [Command]
    def find!(name)
      find(name) || command_not_found!(name)
    end

    private

    def build(name, root)
      Command.new(name: name, root: root, registry: self)
    end

    def command_not_found!(name)
      raise NotFoundError, "There doesn't appear to be a generator named '#{name}'"
    end
  end
end
