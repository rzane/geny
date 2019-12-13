require "geny/actions/find"

RSpec.describe Geny::Actions::Find do
  subject(:find) { described_class.new }

  it "replaces matching files" do
    write "a.txt", "hello"
    find.replace(tmp.to_s, "hello", "goodbye")
    expect(tmp.join("a.txt").read).to eq("goodbye")
  end

  it "replaces matching filenames" do
    write "hello.txt"
    find.rename(tmp.to_s, "hello", "goodbye")
    expect(entries).to eq %w[goodbye.txt]
  end

  it "replaces deeply nested matching filenames" do
    write "hello.txt"
    write "hello/hello.txt"
    write "hello/hello/hello.txt"
    find.rename(tmp.to_s, "hello", "goodbye")

    expect(entries).to eq %w[
      goodbye.txt
      goodbye/goodbye.txt
      goodbye/goodbye/goodbye.txt
    ]
  end

  def entries
    tmp.glob("**/*")
       .select(&:file?)
       .map { |path| path.relative_path_from(tmp) }
       .map(&:to_s)
  end
end
