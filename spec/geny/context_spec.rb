RSpec.describe Geny::Context do
  subject(:context) { build }

  describe "locals" do
    let(:locals) { {value: 1} }
    subject(:context) { build(locals: locals) }

    it "defines readers" do
      expect(context.value).to eq(1)
    end

    it "is available as a hash" do
      expect(context.locals).to eq(locals)
    end
  end

  describe "helpers" do
    it "makes methods available" do
      helper = Module.new do
        def foo
          "bar"
        end
      end

      context = build(helpers: [helper])
      expect(context.foo).to eq("bar")
    end

    it "allows overriding with super" do
      helper = Module.new do
        def value
          super + 1
        end
      end

      context = build(locals: {value: 1}, helpers: [helper])
      expect(context.value).to eq(2)
    end
  end

  describe "#merge" do
    it "allows locals to be merged" do
      before = build(locals: {value: 1})
      after = before.merge(value: 2)

      expect(after.value).to eq(2)
      expect(after).not_to be(before)
      expect(after.locals).not_to be(before.locals)
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

  def build(locals: {}, helpers: [])
    command = instance_double(
      Geny::Command,
      helpers: helpers,
      templates_path: "/"
    )

    Geny::Context.new(command, locals: locals)
  end
end
