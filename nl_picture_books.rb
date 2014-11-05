require "./importio.rb"
require "json" 

#####
# Extracts list of new picture books
# For other categories, I need to make separate ones for each

books_per_page = 48

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.connect

data_rows = []

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
    puts "Query finished"
  end
end

# Page 1
client.query({"input"=>{"webpage/url"=>"http://www.bol.com/nl/l/nederlandse-boeken/nederlandse-boeken-kind-jeugd-prentenboeken/N/69+8293/No/0/index.html?sort=product_datum1"},"connectorGuids"=>["c6837050-1b39-458e-bb5c-cae606923f4c"]}, callback )

# Page 2 and above
(2..4).each do |page|
  client.query({"input"=>{"webpage/url"=>"http://www.bol.com/nl/l/nederlandse-boeken/nederlandse-boeken-kind-jeugd-prentenboeken/N/69+8293/No/#{books_per_page * page}/index.html?sort=product_datum1"},"connectorGuids"=>["c6837050-1b39-458e-bb5c-cae606923f4c"]}, callback )
end

puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

puts "All data received:"
puts JSON.pretty_generate(data_rows)

puts data_rows.size * data_rows[0].size