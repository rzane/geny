RSpec.describe CodeHen do
  it "has a version number" do
    expect(CodeHen::VERSION).not_to be nil
  end

  describe CodeHen::DSL do
    subject(:dsl) { described_class.new }

    it "allows defining arguments" do
      dsl.argument :foo
      expect(dsl.arguments).to eq([:foo])
    end

    it "allows defining options" do
      dsl.option :foo
      expect(dsl.options).to eq([:foo])
    end

    it "has a default parser" do
      expect(dsl.parse.call(value: 1)).to eq(value: 1)
    end

    it "allows defining parse behavior" do
      dsl.parse do |value:|
        {value: value + 1}
      end

      expect(dsl.parse.call(value: 1)).to eq(value: 2)
    end

    it "has a default generator" do
      expect { dsl.generate.call }.to output("I don't know what to do!\n").to_stderr
    end

    it "allows defining generate behavior" do
      dsl.generate do
        puts "hit!"
      end

      expect { dsl.generate.call }.to output("hit!\n").to_stdout
    end
  end
end
