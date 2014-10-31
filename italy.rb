require "./importio.rb"
require "json" 

#################### PART 1 ####################
# Get most recent titles and their book page urls from Amazon Italy

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.connect

data_rows_1 = []

callback = lambda do |query, message|
  if message["type"] == "DISCONNECT"
    puts "The query was cancelled as the client was disconnected"
  end
  if message["type"] == "MESSAGE"
    if message["data"].key?("errorType")
      puts "Got an error!"
      puts JSON.pretty_generate(message["data"])
      data_rows_1 << message["data"]["results"]
  	else
      puts "Got data!"
      puts JSON.pretty_generate(message["data"])
      data_rows_1 << message["data"]["results"]
    end
  end
  if query.finished
    puts "Query finished"
  end
end

client.query({"input"=>{"webpage/url"=>"http://www.amazon.it/s/ref=sr_st_date-desc-rank?__mk_it_IT=%C3%85M%C3%85Z%C3%95%C3%91&unfiltered=1&qid=1414734670&rh=n%3A411663031%2Cn%3A!411664031%2Cn%3A508715031%2Cp_47%3A2014%2Cp_n_binding_browse-bin%3A509801031%2Cp_45%3A1%2Cp_46%3AAfter&sort=date-desc-rank"},"connectorGuids"=>["cbe042bf-7d40-4a98-b1f8-2c58a89b8e09"]}, callback )

# Page 2 and above
(2..3).each do |page|
  client.query({"input"=>{"webpage/url"=>"http://www.amazon.it/s/ref=sr_pg_#{page}/280-7932322-1502062?rh=n%3A411663031%2Cn%3A%21411664031%2Cn%3A508715031%2Cp_47%3A2014%2Cp_n_binding_browse-bin%3A509801031%2Cp_45%3A1%2Cp_46%3AAfter&page=2&sort=date-desc-rank&unfiltered=1&ie=UTF8&qid=1414735761"},"connectorGuids"=>["cbe042bf-7d40-4a98-b1f8-2c58a89b8e09"]}, callback )
end


puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

puts "All data received:"
puts JSON.pretty_generate(data_rows_1)

# Create a new json file unless it already exists
File.new('data/italy_part_1.json', 'w') unless File.exists?('data/italy_part_1.json')
# Open the file and write the data results to results_file.json
File.open('data/italy_part_1.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows_1)
end

i = 0
until i == data_rows_1.size
  puts "Page #{i}: #{data_rows_1[i].size} titles"
  i += 1
end

# Get book page urls from data_rows_1
book_page_urls = []
i = 0
n = 0
until i == data_rows_1.size
  until n == data_rows_1[i].size
    book_page_urls << data_rows_1[i][n]["book_page_url"]
    n += 1
  end
  i += 1
  n = 0
end

puts book_page_urls
puts book_page_urls.size

#################### PART 2 ####################
# With given book_page_urls, go to each page and extract data

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.connect

data_rows_2 = []
query_num = 0

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
    query_num += 1
    puts "Query #{query_num} finished"
  end
end

# Query for tile it_amazon_ext
book_page_urls.each do |url|
  client.query({"input"=>{"webpage/url"=>url},"connectorGuids"=>["92e0ae4b-dc84-47ad-9ac0-c138ab460200"]}, callback )
end

puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

puts "All data received:"
puts JSON.pretty_generate(data_rows_2)

# Create a new json file unless it already exists
File.new('data/italy_part_2.json', 'w') unless File.exists?('data/italy_part_2.json')
# Open the file and write the data results to results_file.json
File.open('data/italy_part_2.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows_2)
end
