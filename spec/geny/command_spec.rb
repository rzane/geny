require "tmpdir"
require "geny/command"
require "geny/registry"

RSpec.describe Geny::Command do
  let(:name) { "foo" }
  let(:root) { tmp.join("foo").to_s }
  let(:file) { tmp.join("foo/generator.rb").to_s }
  let(:templates) { tmp.join("foo/templates").to_s }
  let(:registry) { instance_double(Geny::Registry) }

  subject(:command) {
    Geny::Command.new(
      name: name,
      root: root,
      registry: registry
    )
  }

  describe "#name" do
    it "has a name" do
      expect(command.name).to eq(name)
    end
  end

  describe "#root" do
    it "has a root" do
      expect(command.root).to eq(root)
    end
  end

  describe "#registry" do
    it "has a registry" do
      expect(command.registry).not_to be_nil
    end
  end

  describe "#file" do
    it "has a file" do
      expect(command.file).to eq(file)
    end
  end

  describe "#templates" do
    it "has a templates_path" do
      expect(command.templates_path).to eq(templates)
    end
  end

  describe "#parser" do
    it "has a parser" do
      command.define {}
      expect(command.parser).to be_an(Argy::Parser)
    end
  end

  describe "#description" do
    it "has a description" do
      command.define { parse { description "cool" } }
      expect(command.description).to eq("cool")
    end

    it "is loaded from a file" do
      write file, "parse { description 'cool' }"
      expect(command.description).to eq("cool")
    end
  end

  describe "#helpers" do
    it "has helpers" do
      command.define do
        helpers {}
        helpers {}
      end

      expect(command.helpers.length).to be(2)
    end
  end

  describe "#parse" do
    it "parses arguments" do
      command.define do
        parse { option :value, type: :integer }
      end

      options = command.parse(["--value", "1"])
      expect(options.value).to eq(1)
    end
  end

  describe "#run" do
    it "can be run with arguments" do
      options = {}
      command.define do
        parse { option :value, type: :integer }
        invoke { options.merge!(value: value, value?: value?) }
      end

      command.run(["--value", "99"])
      expect(options).to eq(value: 99, value?: true)
    end

    it "raises when invoked with invalid arguments" do
      command.define do
        parse { option :value, required: true }
      end

      expect { command.run([]) }.to raise_error(Argy::ValidationError)
    end
  end

  describe "#invoke" do
    it "can be invoked with options" do
      options = {}
      command.define do
        parse { option :value, type: :integer }
        invoke { options.merge!(value: value, value?: value?) }
      end

      command.invoke(value: 99)
      expect(options).to eq(value: 99, value?: true)
    end

    it "raises when invoked with invalid options" do
      command.define do
        parse { option :value, required: true }
      end

      expect { command.invoke }.to raise_error(Argy::ValidationError)
    end
  end
end
