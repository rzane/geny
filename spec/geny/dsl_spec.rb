require "geny/dsl"

RSpec.describe Geny::DSL do
  subject(:dsl) { described_class.new }

  it "has a default invocation" do
    expect { dsl.invoke.call }.to output("I don't know what to do!\n").to_stderr
  end

  it "allows defining invocation behavior" do
    dsl.invoke do
      puts "hit!"
    end

    expect { dsl.invoke.call }.to output("hit!\n").to_stdout
  end
end
