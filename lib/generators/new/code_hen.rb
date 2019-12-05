parse do |o|
  o.string "--name", "name for your generator"
end

generate do
  require "fileutils"

  dir = File.join(*name.split(":"))
  file = File.join(dir, "code_hen.rb")

  FileUtils.mkdir_p(dir)
  File.write(file, <<~RUBY)
    parse do |o|
      o.banner = "print a message"
      o.string "-m", "--message"
    end

    generate do
      puts message
    end
  RUBY
end
