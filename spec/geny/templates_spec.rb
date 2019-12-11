require "geny/actions/templates"

RSpec.describe Geny::Templates do
  include TemporaryFileHelpers

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

  def build(**opts)
    Geny::Templates.new(root: tmp.to_s, **opts)
  end
end
