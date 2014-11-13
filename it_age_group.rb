require "./importio.rb"
require "json" 

# Open up file storing isbns and save them into an array
isbns = []
File.readlines('data/it_age_group_resource.txt').each do |line|
  isbns << line
end

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.connect

data_rows = []
query_id = 0

callback = lambda do |query, message|
  if message["type"] == "DISCONNECT"
    puts "The query was cancelled as the client was disconnected"
  end
  if message["type"] == "MESSAGE"
    if message["data"].key?("errorType")
      puts "Got an error!"
      puts JSON.pretty_generate(message["data"])
  	else
      puts "Got data!"
      puts JSON.pretty_generate(message["data"])
      data_rows << message["data"]["results"]
    end
  end
  if query.finished
    query_id += 1
    puts "Query #{query_id} / #{isbns.size} finished"
  end
end

# Query for tile it_search_and_extract_feltrinelli
isbns.each do |isbn|
  client.query({"input"=>{"isbn"=>isbn},"connectorGuids"=>["b7b06882-4e42-49c4-b3c2-098d6bf938c8"]}, callback )
end


puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

puts "All data received:"
puts JSON.pretty_generate(data_rows)

File.new('data/it_age_group_results.json', 'w') unless File.exists?('data/it_age_group_results.json')
File.open('data/it_age_group_results.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows)
end