require "geny/context/invoke"

RSpec.describe Geny::Context::Invoke do
  let(:command) {
    instance_double(Geny::Command, helpers: [], templates_path: "")
  }

  subject(:context) {
    Geny::Context::Invoke.new(command: command)
  }

  it "tries to minimize the number of methods in scope" do
    actions = Geny::Context::Invoke.instance_methods
    actions -= Object.instance_methods

    expect(actions.sort).to eq %i(
      color
      command
      files
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

end
