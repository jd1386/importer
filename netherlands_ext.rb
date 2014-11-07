require "./importio.rb"
require "json" 
require "csv"


client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")



# Extract only book_page_urls from data_rows
book_page_urls = []
File.readlines('data/netherlands_tmp.txt').each do |line|
  book_page_urls << line
end

total_books_count = book_page_urls.size


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
    else
      puts "Got data!"
      puts JSON.pretty_generate(message["data"])
      data_rows_2 << message["data"]["results"]
    end
  end
  if query.finished
    query_id += 1
    puts "Query #{query_id} / #{total_books_count} finished"
  end
end

# Query for tile nl_ext
book_page_urls.each do |url|
  client.query({"input"=>{"webpage/url"=>url},"connectorGuids"=>["d6c5b74a-56dd-48b6-95a9-f717a277343d"]}, callback )
end

puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

puts "All data received:"
puts JSON.pretty_generate(data_rows_2)

# Create a new json file unless it already exists
File.new('data/netherlands_tmp.json', 'w') unless File.exists?('data/netherlands_tmp.json')
# Open the file and write the data results to results_file.json
File.open('data/netherlands_tmp.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows_2)
end