parse do
  description "create a new generator"
  argument :name, desc: "name for your generator", required: true
  option :output, desc: "output directory", default: Dir.pwd
end

invoke do
  require "fileutils"

  FileUtils.mkdir_p(dirname)
  File.write(filename, <<~RUBY)
    parse do
      argument :message, required: true
    end

    invoke do
      puts message
    end
  RUBY
end

helpers do
  def dirname
    File.join(output, *name.split(":"))
  end

  def filename
    File.join(dirname, "generator.rb")
  end
end
