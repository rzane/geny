require "geny/actions/find"

RSpec.describe Geny::Actions::Find do
  subject(:find) { described_class.new }

  it "replaces matching files" do
    write "a.txt", "hello"
    find.and_replace(tmp.to_s, "hello", "goodbye")
    expect(tmp.join("a.txt").read).to eq("goodbye")
  end

  it "replaces matching filenames" do
    write "hello.txt"
    find.and_rename(tmp.to_s, "hello", "goodbye")
    expect(tmp.join("hello.txt")).not_to be_file
    expect(tmp.join("goodbye.txt")).to be_file
  end
end
