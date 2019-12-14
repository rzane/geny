require "geny/dsl"

RSpec.describe Geny::DSL do
  subject(:dsl) { described_class.new }

  describe "#invoke" do
    it "has a default invocation" do
      expect { dsl.invoke.call }.to output("I don't know what to do!\n").to_stderr
    end

    it "allows defining invocation behavior" do
      dsl.invoke { puts "hit!" }
      expect { dsl.invoke.call }.to output("hit!\n").to_stdout
    end
  end

  describe "#parser" do
    it "has a parser" do
      expect(dsl.parser).to be_an(Argy::Parser)
    end
  end

  describe "#parse" do
    it "allows a parser to be defined" do
      dsl.parse { option :name }
      expect(dsl.parser.options.length).to eq(1)
    end
  end

  describe "#helpers" do
    it "has helpers" do
      expect(dsl.helpers).to eq([])
    end

    it "allow helpers to be defined with a block" do
      dsl.helpers {}
      expect(dsl.helpers.first).to be_a(Module)
    end

    it "allows helpers to be defined with a module" do
      mod = Module.new {}
      dsl.helpers mod
      expect(dsl.helpers).to eq([mod])
    end
  end
end
