require "pathname"
require "code_hen/error"
require "code_hen/command"

module CodeHen
  class Registry
    FILENAME = "generator.rb"
    LOAD_PATH = [
      File.join(Dir.pwd, ".generators"),
      *ENV.fetch("CODE_HEN_PATH", "").split(":"),
      File.expand_path("../generators", __dir__)
    ]

    attr_reader :load_path

    def initialize(load_path: LOAD_PATH)
      @load_path = load_path
    end

    def scan
      glob = File.join("**", FILENAME)

      load_path.flat_map do |path|
        path = Pathname.new(path)

        path.glob(glob).map do |file|
          name = file.relative_path_from(path).dirname
          name = name.to_s.tr(File::SEPARATOR, ":")
          Command.new(name: name, file: file.to_s)
        end
      end
    end

    def find(name)
      load_path.each do |path|
        file = File.join(path, *name.split(":"), FILENAME)
        return Command.new(name: name, file: file) if File.exist?(file)
      end

      nil
    end

    def find!(name)
      find(name) || command_not_found!(name)
    end

    private

    def command_not_found!(name)
      raise NotFoundError, "There doesn't appear to be a generator named '#{name}'."
    end
  end
end
