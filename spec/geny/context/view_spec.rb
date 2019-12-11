require "geny/context/view"

RSpec.describe Geny::Context::View do
  let(:locals) { {local: "local"} }
  let(:helpers) { [module_double(helper: "helper")] }
  let(:command) { instance_double(Geny::Command, helpers: helpers) }
  subject(:context) { described_class.new(command: command, locals: locals) }

  it "allows access to locals" do
    expect(context.local).to eq("local")
  end

  it "allows access to helpers" do
    expect(context.helper).to eq("helper")
  end

  it "tries to minimize the number of methods in scope" do
    actions = described_class.instance_methods
    actions -= Object.instance_methods
    expect(actions.sort).to eq %i(command locals merge)
  end

  describe "#merge" do
    it "creates a new view" do
      new_context = context.merge(foo: "bar")
      expect(new_context.local).to eq("local")
      expect(new_context.helper).to eq("helper")
      expect(new_context.foo).to eq("bar")
    end
  end
end
