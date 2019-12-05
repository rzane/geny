require "tmpdir"
require "code_hen/cli"

RSpec.describe CodeHen::CLI do
  let(:tmp)     { Dir.mktmpdir }
  after(:each)  { FileUtils.rm_rf(tmp) }
  subject(:cli) { CodeHen::CLI.new(load_path: [tmp]) }

  it "parses and runs a shallow generator" do
    write "foo/generator.rb", <<~EOS
      invoke { puts "ran foo" }
    EOS

    expect { cli.run(["foo"]) }.to output("ran foo\n").to_stdout
  end

  it "parses and runs a nested generator" do
    write "foo/bar/generator.rb", <<~EOS
      invoke { puts "ran foo/bar" }
    EOS

    expect { cli.run(["foo:bar"]) }.to output("ran foo/bar\n").to_stdout
  end

  it "outputs available commands" do
    write "foo/generator.rb"
    write "bar/buzz/generator.rb", <<~EOS
      parse do
        description "hello"
      end
    EOS

    expect { cli.run([]) }.to output(<<~EOS).to_stdout
      == Generators
      foo
      bar:buzz                                 hello
    EOS
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
