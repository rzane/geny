require "tmpdir"
require "code_hen/command"

RSpec.describe CodeHen::Command do
  let(:tmp)    { Dir.mktmpdir }
  after(:each) { FileUtils.rm_rf(tmp) }

  it "scans the filesystem for generators" do
    write "a/generator.rb"
    write "a/b/generator.rb"
    write "a/b/c/generator.rb"

    commands = CodeHen::Command.scan(load_path: [tmp])
    expect(commands.map(&:name)).to eq(%w(a a:b a:b:c))
  end

  it "has a description" do
    write "a/generator.rb", <<~EOS
      parse do
        description "cool"
      end
    EOS

    command = CodeHen::Command.new(name: "a", file: join("a/generator.rb"))
    expect(command.description).to eq("cool")
  end

  def join(filename)
    File.join(tmp, filename)
  end

  def write(filename, content = "")
    path = File.join(tmp, filename)
    FileUtils.mkdir_p File.dirname(path)
    File.write(path, content)
  end
end
