require "tmpdir"
require "code_hen/cli"

RSpec.describe CodeHen::CLI do
  let(:tmp)    { Pathname.new(Dir.mktmpdir) }
  after(:each) { FileUtils.rm_rf(tmp) }

  it "parses and runs a shallow generator" do
    cli = CodeHen::CLI.new(roots: [tmp.to_s], argv: ["foo"])

    tmp.join("foo").mkdir
    tmp.join("foo/generator.rb").write <<~EOS
      invoke { puts "ran foo" }
    EOS

    expect { cli.run }.to output("ran foo\n").to_stdout
  end

  it "parses and runs a nested generator" do
    cli = CodeHen::CLI.new(roots: [tmp.to_s], argv: ["foo:bar"])

    tmp.join("foo").mkdir
    tmp.join("foo/bar").mkdir
    tmp.join("foo/bar/generator.rb").write <<~EOS
      invoke { puts "ran foo/bar" }
    EOS

    expect { cli.run }.to output("ran foo/bar\n").to_stdout
  end
end
