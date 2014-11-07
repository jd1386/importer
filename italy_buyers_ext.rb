##### DESCRIPTION
# Search Italian buyer publishers' recent titles and get their meta

publisher = 'Mondadori'

##### PART 1
# Go to Feltrinelli and search for publisher 
# And extract book page urls to extract isbn

require "./importio.rb"
require "json" 

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")
client.connect
data_rows = []
books_per_page = 40
query_id = 0

callback = lambda do |query, message|
  if message["type"] == "DISCONNECT"
    puts "The query was cancelled as the client was disconnected"
  end
  if message["type"] == "MESSAGE"
    if message["data"].key?("errorType")
      # In this case, we received a message, but it was an error from the external service
      puts "Got an error!"
      puts JSON.pretty_generate(message["data"])
    else
      # We got a message and it was not an error, so we can process the data
      puts "Got data!"
      puts JSON.pretty_generate(message["data"])
      # Save the data we got in our dataRows variable for later
      data_rows << message["data"]["results"]
    end
  end
  if query.finished
    query_id += 1
    puts "Query #{query_id} finished"
  end
end

# Query for tile it_f_books_per_publisher
# Page 1
client.query({"input"=>{"webpage/url"=>"http://www.lafeltrinelli.it/fcom/it/home/pages/catalogo/searchresults.html?prkw=#{publisher}&cat2=1045&cat1=1&type=1&sort=0&pageSize=40&page=1"},"connectorGuids"=>["375c7738-1c30-4aea-aaae-988580fbbc2f"]}, callback )

# Page 2 and above
(2..8).each do |page|
  client.query({"input"=>{"webpage/url"=>"http://www.lafeltrinelli.it/fcom/it/home/pages/catalogo/searchresults.html?prkw=#{publisher}&cat2=1045&cat1=1&type=1&sort=0&pageSize=40&page=#{page}"},"connectorGuids"=>["375c7738-1c30-4aea-aaae-988580fbbc2f"]}, callback )
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
    isbns << data_rows[i][n]['book_page_url'].match(/[97].{12}/)
    n += 1
  end
  i += 1
  n = 0
end

puts isbns
puts isbns.size
puts "data_rows.size: #{data_rows[0].size}"

puts "#{publisher} finished successfully."
