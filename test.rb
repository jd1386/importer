
require "./importio.rb"
require 'json'
require 'rubygems'

###
data_rows_2 = JSON.parse(File.open('data/italy_part_1.json').read)



puts data_rows_2[14].nil?
puts data_rows_2[14][0].nil?
puts data_rows_2[1814].nil?
puts data_rows_2[1814].nil?


# puts data_rows_2[14][0]["book_page_url"]

puts data_rows_2.count


###
# Extract book page urls from data_rows_2
book_page_urls = []
i = 0

until i == data_rows_2.size
  if data_rows_2[i][0].nil?
    book_page_urls << "emptyyy"
    puts "emptyyy: id #{i}"
  else
    book_page_urls << data_rows_2[i][0]["book_page_url"]
    puts data_rows_2[i][0]["book_page_url"]
    puts "id #{i}"
  end
  i += 1
end

puts book_page_urls


### STEP 3 ###

# name: it_amazon_book_ext
# With given urls in book_page_urls, we now query for each url and extract meta data.

puts "\n... ENTERING PART 3 ...\n"

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==")
client.connect

data_rows_3 = []
query_num = 0
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
    query_num += 1
    puts "Amazon Extract #{query_num} finished"
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
File.new('data/italy_part_2.json', 'w') unless File.exists?('data/italy_part_2.json')
# Open the file and write the data results to results_file.json
File.open('data/italy_part_2.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows_3)
end

puts "All done! You can see the results in data/italy_part_2.json."
