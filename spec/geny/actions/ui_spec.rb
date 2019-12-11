require "geny/actions/ui"

RSpec.describe Geny::Actions::UI do
  let(:color) { Pastel.new(enabled: false) }
  subject(:ui) { described_class.new(color: color) }

  it "has a color" do
    expect(ui.color).to be(color)
  end

  it "prints a message" do
    expect { ui.say "hi" }.to output("hi\n").to_stdout
  end

  it "prints a heading" do
    expect { ui.heading "hi" }.to output("== hi\n").to_stdout
  end

  it "prints a status" do
    expect(color).to receive(:green).and_call_original

    expect {
      ui.status("foo", "bar")
    }.to output("         foo  bar\n").to_stdout
  end

  it "prints a status with a different color" do
    expect(color).to receive(:blue).and_call_original
    expect {
      ui.status("foo", "bar", color: :blue)
    }.to output("         foo  bar\n").to_stdout
  end
end
