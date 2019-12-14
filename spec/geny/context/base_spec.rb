require "geny/command"
require "geny/context/base"

RSpec.describe Geny::Context::Base do
  let(:locals) { {local: "local"} }
  let(:helpers) { [module_double(helper: "helper")] }
  let(:command) { instance_double(Geny::Command, helpers: helpers) }
  subject(:context) { described_class.new(command: command, locals: locals) }

  it "makes helpers accessible" do
    expect(context.helper).to eq("helper")
  end

  it "makes all locals accessible" do
    expect(context.locals).to eq(locals)
  end

  it "makes locals accessible" do
    expect(context.local).to eq("local")
  end

  it "raises NoMethodError for non-existent locals" do
    expect { context.trash }.to raise_error(NoMethodError)
  end

  it "raises ArgumentError for wrong number of arguments" do
    expect { context.local(:trash) }.to raise_error(ArgumentError)
  end

  it "responds to locals" do
    expect(context.respond_to?(:local)).to be(true)
  end

  it "does not respond to non-locals" do
    expect(context.respond_to?(:trash)).to be(false)
  end

  describe "#method_missing" do
  end
end
