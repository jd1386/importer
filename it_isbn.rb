##### DESCRIPTION
# Search Italian buyer publishers' recent titles from Feltrinelli
# and get their meta from Amazon


### SETTINGS ##################

publisher = "Feltrinelli"
LAST_PAGE = 1

###############################
books_per_page = 40

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
client.query({"input"=>{"webpage/url"=>"http://www.lafeltrinelli.it/fcom/it/home/pages/catalogo/searchresults.html?prkw=#{publisher}&cat2=1045&cat1=1&type=1&sort=0&pageSize=#{books_per_page}&page=1"},"connectorGuids"=>["375c7738-1c30-4aea-aaae-988580fbbc2f"]}, callback )

# Page 2 and above
(2..LAST_PAGE).each do |page|
 client.query({"input"=>{"webpage/url"=>"http://www.lafeltrinelli.it/fcom/it/home/pages/catalogo/searchresults.html?prkw=#{publisher}&cat2=1045&cat1=1&type=1&sort=0&pageSize=#{books_per_page}&page=#{page}"},"connectorGuids"=>["375c7738-1c30-4aea-aaae-988580fbbc2f"]}, callback )
end


puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

puts "All data received"


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
sleep 1

# Create a new json file unless it already exists
File.new('data/it_url_source.txt', 'w') unless File.exists?('data/it_url_source.txt')
# Open the file and write the data results to results_file.json
File.open('data/it_url_source.txt', 'w') do |f|
  isbns.each { |isbn| f.puts(isbn) }
end

puts "All done! See data/it_url_source.txt"