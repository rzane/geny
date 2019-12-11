RSpec.describe Geny::Context::Invoke do
  subject(:context) {
    Geny::Context::Invoke.new
  }

  describe "#ui" do
    it "is a Geny::Actions::UI" do
      expect(context.ui).to be_a(Geny::Actions::UI)
    end
  end

  describe "#files" do
    it "is a Geny::Actions::Files" do
      expect(context.files).to be_a(Geny::Actions::Files)
    end
  end

  describe "#shell" do
    it "is a Geny::Actions::Shell" do
      expect(context.shell).to be_a(Geny::Actions::Shell)
    end
  end

  describe "#git" do
    it "is a Geny::Actions::Git" do
      expect(context.git).to be_a(Geny::Actions::Git)
    end
  end

  describe "#templates" do
    it "is a Geny::Actions::Templates" do
      expect(context.templates).to be_a(Geny::Actions::Templates)
    end
  end

  it "delegates to actions" do
    actions = Geny::Context::Invoke.instance_methods
    actions -= Object.instance_methods

    expect(actions.sort).to eq %i(
      append
      capture
      chmod
      color
      copy
      copy_dir
      create
      create_dir
      files
      git
      git_add
      git_commit
      git_init
      git_repo_path
      heading
      helpers
      insert_after
      insert_before
      locals
      prepend
      remove
      render
      replace
      run
      say
      shell
      status
      templates
      ui
    )
  end
end
