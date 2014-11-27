# Search author on Amazon.it



require "./importio.rb"
require "json" 

# To use an API key for authentication, use the following code:
client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

authors = []
File.readlines('data/author_source.txt').each do |line|
  authors << line.gsub(' ', '+')
end

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
    puts "Query #{query_id} / #{authors.size} finished"
  end
end

# Query
authors.each do |author|
  client.query({"input"=>{"webpage/url"=>"http://www.amazon.it/s/ref=dp_byline_sr_book_1?ie=UTF8&field-author=#{author}&search-alias=english-books"},"connectorGuids"=>["0f7fa295-648a-4251-8903-b851e568029d"]}, callback )
end

puts "Queries dispatched, now waiting for results"
# Now we have issued all of the queries, we can wait for all of the threads to complete meaning the queries are done
client.join
puts "Join completed, all results returned"
client.disconnect

puts "All data received:"
puts JSON.pretty_generate(data_rows)

# Create a new json file unless it already exists
File.new('data/author_results.json', 'w') unless File.exists?('data/author_results.json')
# Open the file and write the data results to results_file.json
File.open('data/author_results.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows)
end

puts "All done! See the results in data/author_results.json"