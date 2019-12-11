require "geny/context/view"

RSpec.describe Geny::Context::View do
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

  def build(locals: {}, helpers: [])
    Geny::Context::View.new(
      locals: locals,
      command: instance_double(Geny::Command, helpers: helpers)
    )
  end
end
