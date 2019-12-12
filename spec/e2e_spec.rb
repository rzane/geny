require "spec_helper"

RSpec.describe "exe/geny", :e2e do
  it "displays help with no arguments" do
    expect(geny).to match("USAGE")
  end

  it "displays help with -h" do
    expect(geny("-h")).to match("USAGE")
  end

  it "displays help with --help" do
    expect(geny("--help")).to match("USAGE")
  end

  it "displays version with -v" do
    expect(geny("-v")).to match(Geny::VERSION)
  end

  it "displays version with --version" do
    expect(geny("--version")).to match(Geny::VERSION)
  end

  it "shows an error for invalid commands" do
    expect(geny("trash", raise_error: false)).to eq(
      "ERROR: There doesn't appear to be a generator named 'trash'\n"
    )
  end

  it "generates a new generator" do
    expect(geny("new", "show:message")).to match(".geny/show/message/generator.rb")
    expect(geny("--help")).to match("show:message")
    expect(geny("show:message", "hello")).to eq("hello\n")
    expect(geny("show:message", "hello", "-l")).to eq("HELLO\n")
  end

  def geny(*args)
    bundle_exec(File.expand_path("../exe/geny", __dir__), *args)
  end

  def bundle_exec(*args)
    gemfile = File.expand_path("../Gemfile", __dir__)
    env = ENV.to_h.merge('BUNDLE_GEMFILE' => gemfile)
    execute(env, "bundle", "exec", *args)
  end

  def execute(*args, raise_error: true, **opts)
    out, status = Open3.capture2e(*args, chdir: tmp, **opts)
    raise out if raise_error && !status.success?
    out
  end
end
