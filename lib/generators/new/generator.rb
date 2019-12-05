parse do
  description "create a new generator"
  argument :name, desc: "name for your generator", required: true
end

invoke do
  outfile.dirname.mkpath
  outfile.write <<~RUBY
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
    output.join(*name.split(":"), "generator.rb")
  end
end
