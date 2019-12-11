RSpec.describe Geny::Context::Invoke do
  subject(:context) {
    Geny::Context::Invoke.new
  }

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

  describe "#templates" do
    it "is a Geny::Actions::Templates" do
      expect(context.templates).to be_a(Geny::Actions::Templates)
    end
  end
end
