require "geny/actions/files"
require "geny/actions/ui"

RSpec.describe Geny::Actions::Files do
  let(:ui) { instance_double(Geny::Actions::UI, status: nil) }

  subject(:files) { described_class.new(ui: ui) }

  describe "#create" do
    it "creates a file" do
      files.create("foo.txt", "hi", verbose: false)
      expect("foo.txt").to be_a_file
      expect("foo.txt").to have_content("hi")
    end
  end

  describe "#remove" do
    it "removes a file" do
      write "foo.txt"
      files.remove("foo.txt", verbose: false)
      expect("foo.txt").not_to be_a_file
    end
  end

  describe "#create" do
    it "creates a dir" do
      files.create_dir("foo", verbose: false)
      expect("foo").to be_a_directory
    end
  end

  describe "#prepend" do
    it "prepends a file" do
      write "foo.txt", "bye"
      files.prepend("foo.txt", "hi\n", verbose: false)
      expect("foo.txt").to have_content("hi\nbye")
    end
  end

  describe "#append" do
    it "appends a file" do
      write "foo.txt", "hi\n"
      files.append("foo.txt", "bye", verbose: false)
      expect("foo.txt").to have_content("hi\nbye")
    end
  end

  describe "#replace" do
    it "replaces a file" do
      write "foo.txt", "hi"
      files.replace("foo.txt", /hi/, "bye", verbose: false)
      expect("foo.txt").to have_content("bye")
    end
  end

  describe "#insert" do
    it "inserts before a matching line in a file" do
      write "foo.txt", "bye"
      files.insert("foo.txt", "hi", before: /bye/, verbose: false)
      expect("foo.txt").to have_content("hibye")
    end

    it "inserts after a matching line in a file" do
      write "foo.txt", "hi"
      files.insert("foo.txt", "bye", after: /hi/, verbose: false)
      expect("foo.txt").to have_content("hibye")
    end
  end

  describe "#insert_before" do
    it "inserts before a matching line in a file" do
      write "foo.txt", "bye"
      files.insert_before("foo.txt", /bye/, "hi", verbose: false)
      expect("foo.txt").to have_content("hibye")
    end
  end

  describe "#insert_after" do
    it "inserts after a matching line in a file" do
      write "foo.txt", "hi"
      files.insert_after("foo.txt", /hi/, "bye", verbose: false)
      expect("foo.txt").to have_content("hibye")
    end
  end

  describe "#move" do
    it "moves a file" do
      write "foo.txt"
      files.move("foo.txt", "bar.txt", verbose: false)
      expect("bar.txt").to be_a_file
      expect("foo.txt").not_to be_a_file
    end
  end

  describe "#chdir" do
    it "changes directory" do
      write "foo/bar.txt", "baz"
      result = files.chdir("foo", verbose: false) { read("bar.txt") }
      expect(result).to eq("baz")
    end
  end

  describe "#chmod" do
    it "chmods a file" do
      write "foo.txt"

      expect {
        files.chmod("foo.txt", 0777, verbose: false)
      }.to change { File.lstat("foo.txt").mode }
    end

    it "chmods a file with +x" do
      write "foo.txt"

      expect {
        files.chmod("foo.txt", "+x", verbose: false)
      }.to change { File.lstat("foo.txt").mode }
    end
  end
end
