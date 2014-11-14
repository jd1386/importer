require "./importio.rb"
require "json" 

# Go to Amazon.it and search for isbn

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

isbns = []
File.readlines('data/it_get_url_source.txt').each do |line|
  isbns << line
end

client.connect
data_rows_2 = []
query_id = 0

callback = lambda do |query, message|
  if message["type"] == "DISCONNECT"
    puts "The query was cancelled as the client was disconnected"
  end
  if message["type"] == "MESSAGE"
    if message["data"].key?("errorType")
      puts "Got an error!"
      puts JSON.pretty_generate(message["data"])
      data_rows_2 << message["data"]["results"]
    else
      puts "Got data!"
      puts JSON.pretty_generate(message["data"])
      data_rows_2 << message["data"]["results"]
    end
  end
  if query.finished
    query_id += 1
    puts "Amazon Search #{query_id} of #{isbns.size} finished"
  end
end

# Query for tile it_amazon_search
isbns.each do |isbn|
  client.query({"input"=>{"isbn"=>isbn},"connectorGuids"=>["684c6261-b4f5-4d81-9526-5268b0564de8"]}, callback )
end

puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect
puts "All data received"

# Create a new json file unless it already exists
File.new('data/it_get_url_results.json', 'w') unless File.exists?('data/it_get_url_results.json')
# Open the file and write the data results to results_file.json
File.open('data/it_get_url_results.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows_2)
end


puts "All done! See the results in data/it_get_url_results.json"