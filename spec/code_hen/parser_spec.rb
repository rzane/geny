require "code_hen/parser"

RSpec.describe CodeHen::Parser do
  subject(:parser) { CodeHen::Parser.new }

  it "parses an option" do
    parser.option :value
    expect(parser.parse(["--value", "foo"])).to have_values(value: "foo")
  end

  it "parses a boolean option" do
    parser.option :value, type: :boolean
    expect(parser.parse(["--value"])).to have_values(value: true)
    expect(parser.parse(["--no-value"])).to have_values(value: false)
  end

  it "parses an integer option" do
    parser.option :value, type: :integer
    expect(parser.parse(["--value", "1"])).to have_values(value: 1)
  end

  it "parses a float option" do
    parser.option :value, type: :float
    expect(parser.parse(["--value", "1.1"])).to have_values(value: 1.1)
  end

  it "parses an array option" do
    parser.option :value, type: :array
    expect(parser.parse(["--value", "one,two"])).to have_values(value: ["one", "two"])
  end

  it "parses a custom option" do
    parser.option :value, type: ->(value) { "custom #{value}" }
    expect(parser.parse(["--value", "foo"])).to have_values(value: "custom foo")
  end

  it "parses a positional arguments" do
    parser.argument :foo
    parser.argument :bar
    expect(parser.parse(["foo"])).to have_values(foo: "foo", bar: nil)
  end

  it "respects aliases" do
    parser.option :value, aliases: ["-v"]
    expect(parser.parse(["-v", "foo"])).to have_values(value: "foo")
  end

  it "respects default values" do
    parser.option :value, default: "foo"
    expect(parser.parse([])).to have_values(value: "foo")
  end

  it "respects missing arguments" do
    parser.argument :value, required: true
    expect { parser.parse([]) }.to raise_error(
      CodeHen::Parser::Error,
      "Missing required arguments: VALUE"
    )
  end

  it "respects required options" do
    parser.option :value, required: true
    expect { parser.parse([]) }.to raise_error(
      CodeHen::Parser::Error,
      "Missing required options: --value"
    )
  end

  it "raises a custom error when coersion fails" do
    parser.option :value, type: :integer
    expect { parser.parse(["--value", ""]) }.to raise_error(
      CodeHen::Parser::Error,
      /"" could not be coerced to a integer/
    )
  end

  it "generates help" do
    parser.usage "example"
    parser.example "$ example foo"
    parser.argument :jint, desc: "do a thing"
    parser.option :fizz, required: true, desc: "blah"
    parser.option :foo_bar, aliases: ["-f"]

    expect(parser.to_s).to eq(<<~EOS)
      Usage:
          example

      Examples:
          $ example foo

      Arguments:
          JINT                             do a thing

      Options:
              --fizz FIZZ                  blah
          -f, --foo-bar FOO_BAR
          -h, --help
    EOS
  end

  def have_values(**values)
    eq(unused_arguments: [], **values)
  end
end
