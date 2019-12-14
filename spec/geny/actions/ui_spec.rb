require "geny/actions/ui"

RSpec.describe Geny::Actions::UI do
  let(:color) { Pastel.new(enabled: false) }
  subject(:ui) { described_class.new(color: color) }

  describe "#color" do
    it "has a color" do
      expect(ui.color).to be(color)
    end
  end

  describe "#say" do
    it "prints a message" do
      expect { ui.say "hi" }.to output("hi\n").to_stdout
    end
  end

  describe "#heading" do
    it "prints a heading" do
      expect { ui.heading "hi" }.to output("== hi\n").to_stdout
    end
  end

  describe "#status" do
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

  describe "#error" do
    it "prints an error" do
      expect {
        ui.error("foo")
      }.to output("ERROR: foo\n").to_stderr
    end
  end

  describe "#abort!" do
    it "prints and error and aborts" do
      expect {
        ui.abort!("foo")
      }.to output("ERROR: foo\n").to_stderr.and raise_error(SystemExit)
    end
  end
end
