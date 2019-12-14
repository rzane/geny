require "geny/command"
require "geny/registry"
require "geny/context/invoke"

RSpec.describe Geny::Context::Invoke do
  let(:locals) { {local: "local"} }
  let(:helpers) { [module_double(helper: "helper")] }
  let(:registry) { instance_double(Geny::Registry) }
  let(:command) {
    instance_double(
      Geny::Command,
      helpers: helpers,
      templates_path: "",
      registry: registry
    )
  }

  subject(:context) {
    described_class.new(command: command, locals: locals)
  }

  it "allows access to locals" do
    expect(context.local).to eq("local")
  end

  it "allows access to helpers" do
    expect(context.helper).to eq("helper")
  end

  it "tries to minimize the number of methods in scope" do
    actions = described_class.instance_methods
    actions -= Object.instance_methods

    expect(actions.sort).to eq %i(
      color
      command
      files
      find
      geny
      git
      locals
      shell
      templates
      ui
    )
  end

  describe "#color" do
    it "is a Pastel" do
      expect(context.ui).to be_a(Geny::Actions::UI)
    end
  end

  describe "#ui" do
    it "is a Geny::Actions::UI" do
      expect(context.ui).to be_a(Geny::Actions::UI)
    end
  end

  describe "#files" do
    it "is a Geny::Actions::Files" do
      expect(context.files).to be_a(Geny::Actions::Files)
    end
  end

  describe "#templates" do
    it "is a Geny::Actions::Templates" do
      expect(context.templates).to be_a(Geny::Actions::Templates)
    end
  end

  describe "#shell" do
    it "is a Geny::Actions::Shell" do
      expect(context.shell).to be_a(Geny::Actions::Shell)
    end
  end

  describe "#git" do
    it "is a Geny::Actions::Git" do
      expect(context.git).to be_a(Geny::Actions::Git)
    end
  end

  describe "#find" do
    it "is a Geny::Actions::Find" do
      expect(context.find).to be_a(Geny::Actions::Find)
    end
  end

  describe "#geny" do
    it "is a Geny::Actions::Geny" do
      expect(context.geny).to be_a(Geny::Actions::Geny)
    end
  end
end
