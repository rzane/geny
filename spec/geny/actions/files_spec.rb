require "geny/actions/files"

RSpec.describe Geny::Actions::Files do
  let(:file) { tmp.join("foo.txt") }
  let(:dir) { tmp.join("foo") }

  subject(:files) { described_class.new }

  it "creates a file" do
    files.create(file, "hi", verbose: false)
    expect(file).to be_file
    expect(file.read).to eq("hi")
  end

  it "removes a file" do
    write file
    files.remove(file, verbose: false)
    expect(file).not_to be_a_file
  end

  it "creates a dir" do
    files.create_dir(dir, verbose: false)
    expect(dir).to be_directory
  end

  it "prepends a file" do
    write file, "bye"
    files.prepend(file, "hi\n", verbose: false)
    expect(file.read).to eq("hi\nbye")
  end

  it "appends a file" do
    write file, "hi\n"
    files.append(file, "bye", verbose: false)
    expect(file.read).to eq("hi\nbye")
  end

  it "replaces a file" do
    write file, "hi"
    files.replace(file, /hi/, "bye", verbose: false)
    expect(file.read).to eq("bye")
  end

  it "inserts before a matching line in a file" do
    write file, "bye"
    files.insert_before(file, /bye/, "hi", verbose: false)
    expect(file.read).to eq("hibye")
  end

  it "inserts after a matching line in a file" do
    write file, "hi"
    files.insert_after(file, /hi/, "bye", verbose: false)
    expect(file.read).to eq("hibye")
  end

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
