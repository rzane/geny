require "geny/actions/files"
require "geny/actions/ui"

RSpec.describe Geny::Actions::Files do
  let(:file) { tmp.join("foo.txt") }
  let(:dir) { tmp.join("foo") }
  let(:ui) { instance_double(Geny::Actions::UI, status: nil) }

  subject(:files) { described_class.new(ui: ui) }

  describe "#create" do
    it "creates a file" do
      files.create(file, "hi", verbose: false)
      expect(file).to be_file
      expect(file.read).to eq("hi")
    end
  end

  describe "#remove" do
    it "removes a file" do
      write file
      files.remove(file, verbose: false)
      expect(file).not_to be_a_file
    end
  end

  describe "#create" do
    it "creates a dir" do
      files.create_dir(dir, verbose: false)
      expect(dir).to be_directory
    end
  end

  describe "#prepend" do
    it "prepends a file" do
      write file, "bye"
      files.prepend(file, "hi\n", verbose: false)
      expect(file.read).to eq("hi\nbye")
    end
  end

  describe "#append" do
    it "appends a file" do
      write file, "hi\n"
      files.append(file, "bye", verbose: false)
      expect(file.read).to eq("hi\nbye")
    end
  end

  describe "#replace" do
    it "replaces a file" do
      write file, "hi"
      files.replace(file, /hi/, "bye", verbose: false)
      expect(file.read).to eq("bye")
    end
  end

  describe "#insert" do
    it "inserts before a matching line in a file" do
      write file, "bye"
      files.insert(file, "hi", before: /bye/, verbose: false)
      expect(file.read).to eq("hibye")
    end

    it "inserts after a matching line in a file" do
      write file, "hi"
      files.insert(file, "bye", after: /hi/, verbose: false)
      expect(file.read).to eq("hibye")
    end
  end

  describe "#insert_before" do
    it "inserts before a matching line in a file" do
      write file, "bye"
      files.insert_before(file, /bye/, "hi", verbose: false)
      expect(file.read).to eq("hibye")
    end
  end

  describe "#insert_after" do
    it "inserts after a matching line in a file" do
      write file, "hi"
      files.insert_after(file, /hi/, "bye", verbose: false)
      expect(file.read).to eq("hibye")
    end
  end

  describe "#move" do
    it "moves a file" do
      write "foo.txt"
      files.move(tmp.join("foo.txt"), tmp.join("bar.txt"), verbose: false)
      expect(tmp.join("bar.txt")).to be_file
      expect(tmp.join("foo.txt")).not_to be_file
    end
  end

  describe "#chdir" do
    it "changes directory" do
      write "foo/bar.txt", "baz"
      result = files.chdir(tmp.join("foo"), verbose: false) do
        File.read("bar.txt")
      end
      expect(result).to eq("baz")
    end
  end

  describe "#chmod" do
    it "chmods a file" do
      write file

      expect {
        files.chmod(file, 0777, verbose: false)
      }.to change { file.lstat.mode }
    end

    it "chmods a file with +x" do
      write file

      expect {
        files.chmod(file, "+x", verbose: false)
      }.to change { file.lstat.mode }
    end
  end
end
