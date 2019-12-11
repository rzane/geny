require "geny/actions/git"
require "geny/actions/shell"
require "geny/actions/ui"

RSpec.describe Geny::Actions::Git do
  let(:ui) { instance_double(Geny::Actions::UI) }
  let(:shell) { Geny::Actions::Shell.new(ui: ui) }
  subject(:git) { described_class.new(shell: shell) }

  describe "#init" do
    it "initializes a repo" do
      git.init chdir: tmp.to_s, verbose: false
      expect(tmp.join(".git")).to be_directory
    end
  end

  describe "#add" do
    it "adds files" do
      write "foo.txt"
      git.init chdir: tmp.to_s, verbose: false
      git.add chdir: tmp.to_s, verbose: false
      expect(added_files).to eq("foo.txt")
    end
  end

  describe "#commit" do
    it "commits added files" do
      write "foo.txt"
      git.init chdir: tmp.to_s, verbose: false
      git.add chdir: tmp.to_s, verbose: false
      git.commit chdir: tmp.to_s, verbose: false, message: "success"
      expect(last_commit_message).to eq("success\n")
    end
  end

  describe "#repo_path" do
    it "determines the location of the git repo" do
      git.init(chdir: tmp.to_s, verbose: false)
      path = git.repo_path(chdir: tmp.to_s)
      path = File.basename(path)
      expect(path).to eq(tmp.basename.to_s)
    end
  end

  def added_files
    shell.capture("git diff --cached --name-only", chdir: tmp.to_s)
  end

  def last_commit_message
    shell.capture("git log -1 --pretty=%B", chdir: tmp.to_s)
  end
end
