parse do
  usage "geny new [NAME]"
  description "create a new generator"
  argument :name, desc: "name for your generator", required: true
end

invoke do
  files.create outfile, <<~RUBY
    parse do
      argument :message, required: true
    end

    invoke do
      puts message
    end
  RUBY
end

helpers do
  def outfile
    File.join(*name.split(":"), Geny::Registry::FILENAME)
  end
end
