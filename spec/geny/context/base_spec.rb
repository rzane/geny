require "geny/context/base"

RSpec.describe Geny::Context::Base do
  let(:locals) { {local: "local"} }
  let(:helpers) { [module_double(helper: "helper")] }
  let(:command) { instance_double(Geny::Command, helpers: helpers) }
  subject(:context) { described_class.new(command: command, locals: locals) }

  it "makes locals available" do
    expect(context.local).to eq("local")
  end

  it "makes helper methods available" do
    expect(context.helper).to eq("helper")
  end

  describe "#locals" do
    it "returns all locals" do
      expect(context.locals).to eq(locals)
    end
  end
end
