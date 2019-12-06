parse do
  argument :message, required: true
end

invoke do
  puts message
end
