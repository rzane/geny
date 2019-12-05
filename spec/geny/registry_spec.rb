require "geny/registry"

RSpec.describe Geny::Registry do
  include TemporaryFileHelpers

  subject(:registry) {
    Geny::Registry.new(load_path: [tmp])
  }

  before do
    write "a/generator.rb"
    write "a/b/generator.rb"
    write "a/b/c/generator.rb"
  end

  describe "#scan" do
    it "scans the filesystem for generators" do
      expect(registry.scan.map(&:name)).to eq(%w(a a:b a:b:c))
    end
  end

  describe "#find" do
    it "finds a generator" do
      command = registry.find("a:b")
      expect(command.name).to eq("a:b")
      expect(command.file).to eq(join("a/b/generator.rb"))
    end

    it "is nil when the generator is not found" do
      expect(registry.find("c")).to be_nil
    end
  end

  describe "#find!" do
    it "finds a generator" do
      command = registry.find!("a:b")
      expect(command.name).to eq("a:b")
      expect(command.file).to eq(join("a/b/generator.rb"))
    end

    it "raises when the generator is not found" do
      expect { registry.find!("c") }.to raise_error(
        Geny::NotFoundError,
        "There doesn't appear to be a generator named 'c'."
      )
    end
  end
end
