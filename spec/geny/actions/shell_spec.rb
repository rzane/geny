require "geny/actions/shell"
require "geny/actions/ui"

RSpec.describe Geny::Actions::Shell do
  let(:ui) { instance_double(Geny::Actions::UI, status: nil) }
  subject(:shell) { described_class.new(ui: ui) }

  describe "#run" do
    it "runs a command" do
      expect(Kernel).to receive(:system).with("echo", "hello world", {})
      expect(ui).to receive(:status).with("run", 'echo "hello world"')
      shell.run("echo", "hello world")
    end

    it "raises an error when a command fails" do
      expect { shell.run("trash-juice") }.to raise_error(
        Geny::ExitError,
        "Command `trash-juice` failed (exit code: 127)"
      )
    end
  end

  describe "#capture" do
    it "captures output" do
      output = shell.capture("echo", "hello world")
      expect(output).to eq("hello world")
    end

    it "raises an error when a command fails" do
      expect { shell.capture("trash-juice") }.to raise_error(
        Geny::ExitError,
        "Command `trash-juice` failed (exit code: 127)"
      )
    end
  end
end
