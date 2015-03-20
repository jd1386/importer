require "importio"
require "json"


isbns = []
File.readlines('data/it_meta_source.txt').each do |line|
  isbns << line
end

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==")
client.connect

data_rows = []
pageUrls = []

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
      pageUrls << message["data"]["pageUrl"]
    else
      puts "Got data!"
      puts JSON.pretty_generate(message["data"]["results"])
      data_rows << message["data"]["results"]
      pageUrls << message["data"]["pageUrl"]
    end
  end
  if query.finished
    query_id += 1
    puts "Extracting meta #{query_id} / #{isbns.size} finished"
  end
end

# Query for tile it_amazon_book_ext
isbns.each do |isbn|
  client.query({"input"=>{"isbn"=>isbn},"connectorGuids"=>["98591cc3-b936-4c10-980e-b61e72540e14"]}, callback )
end

puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect


File.new('data/it_meta_results.json', 'w') unless File.exists?('data/it_meta_results.json')
File.open('data/it_meta_results.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows)
end


puts "All done! See data/it_meta_results.json and data/it_meta_results_url.json"
