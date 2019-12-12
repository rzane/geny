require "pathname"
require "geny/error"
require "geny/command"

module Geny
  class Registry
    LOAD_PATH = [
      File.join(Dir.pwd, ".geny"),
      *ENV.fetch("CODE_HEN_PATH", "").split(":"),
      File.expand_path("../generators", __dir__)
    ]

    attr_reader :load_path

    def initialize(load_path: LOAD_PATH)
      @load_path = load_path
    end

    def scan
      glob = File.join("**", Command::FILENAME)

      commands = load_path.flat_map do |path|
        path = Pathname.new(path)

        path.glob(glob).map do |file|
          root = file.dirname
          name = root.relative_path_from(path)
          name = name.to_s.tr(File::SEPARATOR, ":")
          Command.new(name: name, root: root.to_s)
        end
      end

      commands.sort_by(&:name)
    end

    def find(name)
      load_path.each do |path|
        file = File.join(path, *name.split(":"), Command::FILENAME)
        root = File.dirname(file)
        return Command.new(name: name, root: root) if File.exist?(file)
      end

      nil
    end

    def find!(name)
      find(name) || command_not_found!(name)
    end

    private

    def command_not_found!(name)
      raise NotFoundError, "There doesn't appear to be a generator named '#{name}'"
    end
  end
end
