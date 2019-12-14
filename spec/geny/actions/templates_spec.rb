require "geny/command"
require "geny/context/view"
require "geny/actions/templates"

RSpec.describe Geny::Actions::Templates do
  it "renders" do
    write "hello.erb", "hello world"
    templates = build
    result = templates.render("hello.erb")
    expect(result).to eq("hello world")
  end

  it "renders with locals" do
    write "hello.erb", "hello <%= name %>"
    templates = build(locals: {name: "world"})
    result = templates.render("hello.erb")
    expect(result).to eq("hello world")
  end

  it "renders with extra locals" do
    write "hello.erb", "<%= message %> <%= name %>"
    templates = build(locals: {name: "world"})
    result = templates.render("hello.erb", locals: {message: "hello"})
    expect(result).to eq("hello world")
  end

  it "renders with helpers" do
    write "hello.erb", "hello <%= name %>"

    helper = Module.new do
      def name
        "world"
      end
    end

    write "hello.erb", "hello <%= name %>"
    templates = build(helpers: [helper])
    result = templates.render("hello.erb")
    expect(result).to eq("hello world")
  end

  it "renders with helpers and super" do
    write "hello.erb", "hello <%= name %>"

    helper = Module.new do
      def name
        "#{super}!"
      end
    end

    write "hello.erb", "hello <%= name %>"
    templates = build(helpers: [helper])
    result = templates.render("hello.erb", locals: {name: "world"})
    expect(result).to eq("hello world!")
  end

  it "copies a file" do
    write "hello.erb", "hello <%= name %>"
    output = tmp.join("hello.txt")

    templates = build(locals: {name: "world"})
    templates.copy("hello.erb", output, verbose: false)

    expect(output).to be_file
    expect(output.read).to eq("hello world")
  end

  it "copies a directory" do
    write "hello/%name%.txt.erb", "hello <%= name %>"
    output = tmp.join("world.txt")

    templates = build(locals: {name: "world"})
    templates.copy_dir("hello", tmp, verbose: false)

    expect(output).to be_file
    expect(output.read).to eq("hello world")
  end

  def build(locals: {}, helpers: [])
    command = instance_double(Geny::Command, helpers: helpers)
    view = Geny::Context::View.new(command: command, locals: locals)
    Geny::Actions::Templates.new(root: tmp.to_s, view: view)
  end
end
