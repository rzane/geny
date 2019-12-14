require "geny/dsl"

RSpec.describe Geny::DSL do
  subject(:dsl) { described_class.new }

  it "has a default invocation" do
    expect { dsl.invoke.call }.to output("I don't know what to do!\n").to_stderr
  end

  it "allows defining invocation behavior" do
    dsl.invoke { puts "hit!" }
    expect { dsl.invoke.call }.to output("hit!\n").to_stdout
  end

  it "has a parser" do
    expect(dsl.parser).to be_an(Argy::Parser)
  end

  it "allows a parser to be defined" do
    dsl.parse { option :name }
    expect(dsl.parser.options.length).to eq(1)
  end

  it "has helpers" do
    expect(dsl.helpers).to eq([])
  end

  it "allow helpers to be defined with a block" do
    dsl.helpers {}
    expect(dsl.helpers.length).to eq(1)
  end

  it "allows helpers to be defined with a module" do
    mod = Module.new {}
    dsl.helpers mod
    expect(dsl.helpers.length).to eq(1)
  end
end
