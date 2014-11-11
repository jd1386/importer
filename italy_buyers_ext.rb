##### DESCRIPTION
# Search Italian buyer publishers' recent titles from Feltrinelli
# and get their meta from Amazon


### SETTINGS ##################
publisher = 'De-Agostini'   
LAST_PAGE = 63
books_per_page = 40
###############################


##### Step 1

# Go to Feltrinelli and search for publisher 
# And extract book page urls to extract isbn

require "./importio.rb"
require "json" 

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
    puts "Query #{query_id} / #{LAST_PAGE} finished"
  end
end

# Query for tile it_f_books_per_publisher
# Page 1
client.query({"input"=>{"webpage/url"=>"http://www.lafeltrinelli.it/fcom/it/home/pages/catalogo/searchresults.html?prkw=#{publisher}&cat2=1045&cat1=1&type=1&sort=0&pageSize=80&page=1"},"connectorGuids"=>["375c7738-1c30-4aea-aaae-988580fbbc2f"]}, callback )

# Page 2 and above
(2..LAST_PAGE).each do |page|
  client.query({"input"=>{"webpage/url"=>"http://www.lafeltrinelli.it/fcom/it/home/pages/catalogo/searchresults.html?prkw=#{publisher}&cat2=1045&cat1=1&type=1&sort=0&pageSize=80&page=#{page}"},"connectorGuids"=>["375c7738-1c30-4aea-aaae-988580fbbc2f"]}, callback )
end


puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

puts "All data received:"
puts JSON.pretty_generate(data_rows)


# Create a new json file unless it already exists
File.new('data/italy_buyers_ext.json', 'a') unless File.exists?('data/italy_buyers_ext.json')
# Open the file and write the data results to results_file.json
File.open('data/italy_buyers_ext.json', 'a') do |f|
  f << JSON.pretty_generate(data_rows)
end


# Extract isbn from data_rows
isbns = []
i = 0
n = 0

until i == data_rows.size
  until n == data_rows[i].size
    puts data_rows[i][n]['book_page_url']
    isbns << data_rows[i][n]['book_page_url'].match(/978(?:-?\d){10}/)
    n += 1
  end
  i += 1
  n = 0
end

puts isbns
puts "ISBNS size: #{isbns.size}"

puts 'Examine ISBNS now. If satisfied, press ENTER, otherwise press anything else.'
abort 'Terminated. Retry.' unless gets.chomp.empty?


## STEP 2

# Go to Amazon.it and search for isbn
puts "\n... ENTERING STEP 2 ...\n"
sleep 1

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

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
  sleep 1
end

puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
puts "All data received:"
puts JSON.pretty_generate(data_rows_2)

# Create a new json file unless it already exists
File.new('data/italy_buyers_part_1.json', 'w') unless File.exists?('data/italy_buyers_part_1.json')
# Open the file and write the data results to results_file.json
File.open('data/italy_buyers_part_1.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows_2)
end


# Extract book page urls from data_rows_2
book_page_urls = []
i = 0

until i == data_rows_2.size
  if data_rows_2[i][0].nil?
    book_page_urls << 'emptyyy'
  else
    book_page_urls << data_rows_2[i][0]['book_page_url']
  end
i += 1
end


### STEP 3 ###

# name: it_amazon_book_ext
# With given urls in book_page_urls, we now query for each url and extract meta data.

puts "\n... ENTERING PART 3 ...\n"

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
    puts "Amazon Extract #{query_id} / #{book_page_urls} finished"
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