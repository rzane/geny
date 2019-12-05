require "code_hen/version"

module CodeHen
  class Error < StandardError
  end

  def self.load_path
    @load_path ||= [
      File.join(Dir.pwd, ".generators"),
      *ENV.fetch("CODE_HEN_PATH", "").split(":"),
      File.join(__dir__, "generators")
    ]
  end
end
