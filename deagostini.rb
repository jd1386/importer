require "./importio.rb"
require "json" 


book_page_urls = []
File.readlines('data/deagostini.txt').each do |line|
  book_page_urls << line
end

puts book_page_urls
puts book_page_urls.size


client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==")
client.connect

data_rows_3 = []
query_id = 0
callback = lambda do |query, message|
  if message["type"] == "DISCONNECT"
    puts "The query was cancelled as the client was disconnected"
  end
  if message["type"] == "MESSAGE"
    if message["data"].key?("errorType")
      puts "Got an error!"
      puts JSON.pretty_generate(message["data"])
      data_rows_3 << message["data"]["results"]
    else
      puts "Got data!"
      puts JSON.pretty_generate(message["data"])
      data_rows_3 << message["data"]["results"]
    end
  end
  if query.finished
    query_id += 1
    puts "Amazon Extract #{query_id} / #{book_page_urls.size} finished"
  end
end

# Query for tile it_amazon_book_ext
book_page_urls.each do |url|
  client.query({"input"=>{"webpage/url"=>url},"connectorGuids"=>["320d7136-ea26-46e3-b3c1-eb7427993f8c"]}, callback )
end

puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

# Create a new json file unless it already exists
File.new('data/italy_buyers_part_2.json', 'w') unless File.exists?('data/italy_buyers_part_2.json')
# Open the file and write the data results to results_file.json
File.open('data/italy_buyers_part_2.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows_3)
end

puts "All done! Now merge italy_buyers_part_1.json with italy_buyers_part_2.json."