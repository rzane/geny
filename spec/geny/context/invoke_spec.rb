require "geny/context/invoke"

RSpec.describe Geny::Context::Invoke do
  subject(:context) {
    Geny::Context::Invoke.new(templates_path: "/foo/bar")
  }

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
      status
    )
  end
end
