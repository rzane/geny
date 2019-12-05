parse do
  argument :name, desc: "name for your generator", required: true
  option :output, desc: "output directory", default: Dir.pwd
end

invoke do
  require "fileutils"

  FileUtils.mkdir_p(dirname)
  File.write(filename, <<~RUBY)
    parse do |o|
      o.banner = "print a message"
      o.string "-m", "--message"
    end

    generate do
      puts message
    end
  RUBY
end

helpers do
  def dirname
    File.join(output, *name.split(":"))
  end

  def filename
    File.join(dirname, "")
  end
end
