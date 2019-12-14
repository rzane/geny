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
    path = name.split(Geny::Command::SEPARATOR)
    File.join(".geny", *path, Geny::Command::FILENAME)
  end
end
