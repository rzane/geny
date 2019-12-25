require "geny/actions/find"

RSpec.describe Geny::Actions::Find do
  subject(:find) { described_class.new }

  describe "#replace" do
    it "replaces matching files" do
      write "a.txt", "hello"
      find.replace(".", "hello", "goodbye")
      expect("a.txt").to have_content("goodbye")
    end

    it "ignores excluded files" do
      write "a.txt", "hello"
      write "b.txt", "hello"
      find.replace(".", "hello", "goodbye", excluding: /b/)
      expect("a.txt").to have_content("goodbye")
      expect("b.txt").to have_content("hello")
    end
  end

  describe "#replace" do
    it "replaces matching filenames" do
      write "hello.txt"
      find.rename(".", "hello", "goodbye")
      expect(".").to have_entries(%w[goodbye.txt])
    end

    it "ignores excluded files" do
      write "hello.txt"
      write "hello-world.txt"
      find.rename(".", "hello", "goodbye", excluding: /world/)
      expect(".").to have_entries(%w[goodbye.txt hello-world.txt])
    end

    it "replaces deeply nested matching filenames" do
      write "hello.txt"
      write "hello/hello.txt"
      write "hello/hello/hello.txt"
      find.rename(".", "hello", "goodbye")

      expect(".").to have_entries(%w[
        goodbye.txt
        goodbye/goodbye.txt
        goodbye/goodbye/goodbye.txt
      ])
    end

    it "replaces deeply nested matching directories" do
      write "hello/hello/foo.txt"
      find.rename(".", "hello", "goodbye")
      expect(".").to have_entries(%w[goodbye/goodbye/foo.txt])
    end
  end
end
