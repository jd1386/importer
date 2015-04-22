require 'open-uri'
require 'json'
require 'csv'

email_inputs = ['lee.jungdo@gmail.com', 'jungdo@orights.com', 'heawon.hailey@orights.com', 'abc@a.c']


email_inputs.each do |email|
  puts "Querying #{email}"
  content = JSON.parse(open("https://api.import.io/store/data/5d8a8c21-c2a4-4ee0-90af-1c0a9a9f2d24/_query?input/email=#{email}&_user=3f9ae37e-acfd-44f4-8157-e72adcc5b283&_apikey=3f9ae37e-acfd-44f4-8157-e72adcc5b283%3A93CLLmP2bc%2FxrnSLz8b0BAsVyjebOMqgkxsEz%2FzmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg%3D%3D").read)

  if content
    puts content["results"]
  else
    puts "No content"
    next
  end

end
