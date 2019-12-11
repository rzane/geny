parse do
  usage "geny new [NAME]"
  description "create a new generator"
  argument :name, desc: "name for your generator", required: true
end

invoke do
  templates.copy "generator.rb.erb", generator_path
end

helpers do
  def generator_path
    File.join(".geny", *name.split(":"), Geny::Registry::FILENAME)
  end
end
