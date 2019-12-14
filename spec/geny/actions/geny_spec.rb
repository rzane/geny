require "geny/command"
require "geny/registry"
require "geny/actions/geny"

RSpec.describe Geny::Actions::Geny do
  let(:command) { instance_double(Geny::Command) }
  let(:registry) { instance_double(Geny::Registry, find!: command) }
  subject(:geny) { described_class.new(registry: registry) }

  it "runs a command with arguments" do
    expect(command).to receive(:run).with(["--name", "foo"])
    geny.run "cmd", "--name", "foo"
  end

  it "invokes a command with options" do
    expect(command).to receive(:invoke).with(name: "foo")
    geny.invoke "cmd", name: "foo"
  end
end
