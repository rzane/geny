require "tmpdir"
require "geny/command"

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

  it "has a name" do
    expect(command.name).to eq(name)
  end

  it "has a root" do
    expect(command.root).to eq(root)
  end

  it "has a file" do
    expect(command.file).to eq(file)
  end

  it "has a templates_path" do
    expect(command.templates_path).to eq(templates)
  end

  it "has a parser" do
    command.define {}
    expect(command.parser).to be_an(Argy::Parser)
  end

  it "has a description" do
    command.define { parse { description "cool" } }
    expect(command.description).to eq("cool")
  end

  it "has helpers" do
    command.define do
      helpers {}
      helpers {}
    end

    expect(command.helpers.length).to be(2)
  end

  it "parses arguments" do
    command.define do
      parse { option :value, type: :integer }
    end

    options = command.parse(["--value", "1"])
    expect(options.value).to eq(1)
  end

  it "loads the command from a file" do
    write file, "parse { description 'cool' }"
    expect(command.description).to eq("cool")
  end

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
