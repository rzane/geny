require "geny/actions/find"

RSpec.describe Geny::Actions::Find do
  subject(:find) { described_class.new }

  describe "#replace" do
    it "replaces matching files" do
      write "a.txt", "hello"
      find.replace(tmp.to_s, "hello", "goodbye")
      expect(tmp.join("a.txt").read).to eq("goodbye")
    end

    it "ignores excluded files" do
      write "a.txt", "hello"
      write "b.txt", "hello"
      find.replace(tmp.to_s, "hello", "goodbye", excluding: /b/)
      expect(tmp.join("a.txt").read).to eq("goodbye")
      expect(tmp.join("b.txt").read).to eq("hello")
    end
  end

  describe "#replace" do
    it "replaces matching filenames" do
      write "hello.txt"
      find.rename(tmp.to_s, "hello", "goodbye")
      expect(entries).to match_array %w[goodbye.txt]
    end

    it "ignores excluded files" do
      write "hello.txt"
      write "hello-world.txt"
      find.rename(tmp.to_s, "hello", "goodbye", excluding: /world/)
      expect(entries).to match_array %w[goodbye.txt hello-world.txt]
    end

    it "replaces deeply nested matching filenames" do
      write "hello.txt"
      write "hello/hello.txt"
      write "hello/hello/hello.txt"
      find.rename(tmp.to_s, "hello", "goodbye")

      expect(entries).to match_array %w[
        goodbye.txt
        goodbye/goodbye.txt
        goodbye/goodbye/goodbye.txt
      ]
    end

    it "replaces deeply nested matching directories" do
      write "hello/hello/foo.txt"
      find.rename(tmp.to_s, "hello", "goodbye")
      expect(entries).to match_array %w[goodbye/goodbye/foo.txt]
    end
  end

  def entries
    tmp.glob("**/*")
       .select(&:file?)
       .map { |path| path.relative_path_from(tmp) }
       .map(&:to_s)
  end
end
