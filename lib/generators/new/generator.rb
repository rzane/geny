parse do
  usage "geny new [NAME]"
  description "create a new generator"
  argument :name, desc: "name for your generator", required: true
end

invoke do
  copy "generator.rb.erb", outfile, context: self
end

helpers do
  def outfile
    File.join(".geny", *name.split(":"), Geny::Registry::FILENAME)
  end
end
