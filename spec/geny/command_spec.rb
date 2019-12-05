require "tmpdir"
require "geny/command"

RSpec.describe Geny::Command do
  include TemporaryFileHelpers

  it "has a description" do
    write "a/generator.rb", <<~EOS
      parse do
        description "cool"
      end
    EOS

    command = Geny::Command.new(name: "a", file: join("a/generator.rb"))
    expect(command.description).to eq("cool")
  end
end
