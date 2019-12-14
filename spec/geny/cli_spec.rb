require "tmpdir"
require "geny/cli"

RSpec.describe Geny::CLI do
  let(:registry) {
    Geny::Registry.new(load_path: [tmp.to_s])
  }

  subject(:cli) {
    Geny::CLI.new(registry: registry)
  }

  describe "#run" do
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

    it "outputs help with no arguments" do
      expect {
        cli.run([])
      }.to output(/USAGE/).to_stdout.and raise_error(SystemExit)
    end

    it "outputs help with -h" do
      expect {
        cli.run(["-h"])
      }.to output(/USAGE/).to_stdout.and raise_error(SystemExit)
    end

    it "outputs help with --help" do
      expect {
        cli.run(["--help"])
      }.to output(/USAGE/).to_stdout.and raise_error(SystemExit)
    end

    it "outputs version with -v" do
      expect {
        cli.run(["-v"])
      }.to output("#{Geny::VERSION}\n").to_stdout.and raise_error(SystemExit)
    end

    it "outputs version with --version" do
      expect {
        cli.run(["--version"])
      }.to output("#{Geny::VERSION}\n").to_stdout.and raise_error(SystemExit)
    end

    it "shows the list of generators in the help" do
      write "foo/bar/generator.rb"
      expect {
        cli.run(["-h"])
      }.to output(/COMMANDS\n  foo:bar/).to_stdout.and raise_error(SystemExit)
    end
  end

  describe "#abort!" do
    it "exits the program with an error" do
      expect {
        cli.abort!("BOOM")
      }.to output(/ERROR.*BOOM/).to_stderr.and raise_error(SystemExit)
    end
  end
end
