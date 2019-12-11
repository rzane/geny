require "geny/context/invoke"

RSpec.describe Geny::Context::Invoke do
  let(:command) {
    instance_double(Geny::Command)
  }

  subject(:context) {
    Geny::Context::Invoke.new(command: command)
  }

  it "delegates to actions" do
    actions = Geny::Context::Invoke.instance_methods
    actions -= Object.instance_methods

    expect(actions.sort).to eq %i(
      color
      command
      files
      git
      locals
      shell
      templates
      ui
    )
  end
end
