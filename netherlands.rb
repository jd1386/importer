require "./importio.rb"
require "json" 

##### PART 1
# Extracts list of new picture books
# For other categories, I need to make separate ones for each

books_per_page = 48

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
    puts "Query #{query_id} finished"
  end
end

# Query all children's books sorted by pub date
# Page 1
client.query({"input"=>{"webpage/url"=>"http://www.bol.com/nl/l/nederlandse-boeken/nederlandse-boeken-kind-jeugd/N/60+8293/index.html?sort=product_datum1"},"connectorGuids"=>["c6837050-1b39-458e-bb5c-cae606923f4c"]}, callback )

# Page 2 and above
(26..30).each do |page|
  client.query({"input"=>{"webpage/url"=>"http://www.bol.com/nl/l/nederlandse-boeken/nederlandse-boeken-kind-jeugd/N/60+8293/No/#{books_per_page * page}/index.html?sort=product_datum1"},"connectorGuids"=>["c6837050-1b39-458e-bb5c-cae606923f4c"]}, callback )
end

puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

puts "All data received:"
puts JSON.pretty_generate(data_rows)

# Create a new json file unless it already exists
File.new('data/netherlands_part_1.json', 'w') unless File.exists?('data/netherlands_part_1.json')
# Open the file and write the data results to results_file.json
File.open('data/netherlands_part_1.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows)
end

total_books_count = data_rows.size * data_rows[0].size
puts "There are #{total_books_count} books total."
sleep 2

# Extract only book_page_urls from data_rows
book_page_urls = []
i = 0
n = 0

until i == data_rows.size
  until n == data_rows[i].size
    book_page_urls << data_rows[i][n]["book_page_url"]
    n += 1
  end
  n = 0
  i += 1
end

puts book_page_urls

if total_books_count != book_page_urls.size
  abort "total_books_count and book_page_urls.size mismatch! Aborted.."
else
  puts "Successfully extracted #{book_page_urls.size} titles!"
end




###### PART 2

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
File.new('data/netherlands_part_2.json', 'w') unless File.exists?('data/netherlands_part_2.json')
# Open the file and write the data results to results_file.json
File.open('data/netherlands_part_2.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows_2)
end