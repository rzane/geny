require "geny/command"
require "geny/context/view"
require "geny/actions/templates"

RSpec.describe Geny::Actions::Templates do
  describe "#render" do
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

    it "renders with capture and concat" do
      helper = Module.new do
        def hello(&block)
          concat "hello #{capture(&block)}"
          nil
        end
      end

      write "hello.erb", "<% hello do %>world<% end %>"
      templates = build(helpers: [helper])
      result = templates.render("hello.erb")
      expect(result).to eq("hello world")
    end
  end

  describe "#copy" do
    it "copies a file" do
      write "hello.erb", "hello <%= name %>"

      templates = build(locals: {name: "world"})
      templates.copy("hello.erb", "hello.txt", verbose: false)

      expect("hello.txt").to be_a_file
      expect("hello.txt").to have_content("hello world")
    end
  end

  describe "#copy_dir" do
    it "copies a directory" do
      write "a/%name%.txt.erb", "hello <%= name %>"

      templates = build(locals: {name: "world"})
      templates.copy_dir("a", "b", verbose: false)

      expect("b/world.txt").to be_a_file
      expect("b/world.txt").to have_content("hello world")
    end
  end

  def build(locals: {}, helpers: [])
    command = instance_double(Geny::Command, helpers: helpers)
    view = Geny::Context::View.new(command: command, locals: locals)
    Geny::Actions::Templates.new(root: Dir.pwd, view: view)
  end
end
