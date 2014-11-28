require "importio"


book_page_urls = []
File.readlines('data/it_meta_source.txt').each do |line|
  book_page_urls << line
end

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==")
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
      data_rows << message["data"]["results"]
    else
      puts "Got data!"
      puts JSON.pretty_generate(message["data"]["results"])
      data_rows << message["data"]["results"]
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


File.new('data/it_meta_results.json', 'w') unless File.exists?('data/it_meta_results.json')
File.open('data/it_meta_results.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows)
end

puts "All done! See data/it_meta_results.json."