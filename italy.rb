require "./importio.rb"
require "json" 

#################### PART 1 ####################
# name: it_amazon_recent
# Get most recent titles and their book page urls from Amazon Italy

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.connect

data_rows_1 = []
query_num = 0
i = 0

callback = lambda do |query, message|
  if message["type"] == "DISCONNECT"
    puts "The query was cancelled as the client was disconnected"
  end
  if message["type"] == "MESSAGE"
    if message["data"].key?("errorType")
      puts "Got an error!"
      puts JSON.pretty_generate(message["data"])
      data_rows_1 << message["data"]["results"]
      if data_rows_1[i].empty?
        abort "\nFailed. Terminated."
      end
  	else
      puts "Got data!"
      puts JSON.pretty_generate(message["data"])
      data_rows_1 << message["data"]["results"]
      if data_rows_1[i].empty?
        abort "\nWTF?! Failed at page #{i + 1}. Terminated.\n"
      else
        i += 1
      end
    end
  end
  if query.finished
    query_num += 1
    puts "Page #{query_num} finished"
  end
end

# Page 1
# client.query({"input"=>{"webpage/url"=>"http://www.amazon.it/s/ref=sr_st_date-desc-rankhttp://www.amazon.it/s/ref=sr_adv_b?page_nav_name=Libri+in+italiano&search-alias=stripbooks&unfiltered=1&__mk_it_IT=%C5M%C5Z%D5%D1&field-keywords=&field-author=&field-title=&field-isbn=&field-publisher=&node=508715031&field-binding_browse-bin=&field-dateop=After&field-datemod=1&field-dateyear=2014&sort=-pubdate&Adv-Srch-Books-Submit.x=43&Adv-Srch-Books-Submit.y=8"},"connectorGuids"=>["cbe042bf-7d40-4a98-b1f8-2c58a89b8e09"]}, callback )
sleep 2

# Page 2 and above
(21..75).each do |page|
  client.query({"input"=>{"webpage/url"=>"http://www.amazon.it/s/ref=sr_pg_#{page}?rh=n%3A411663031%2Cn%3A%21411664031%2Cn%3A508715031%2Cp_47%3A2014%2Cp_45%3A1%2Cp_46%3AAfter&page=#{page}&sort=-pubdate&unfiltered=1&ie=UTF8"},"connectorGuids"=>["cbe042bf-7d40-4a98-b1f8-2c58a89b8e09"]}, callback )
  sleep 2
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

i = 0
until i == data_rows_1.size
  puts "Page #{i + 1}: #{data_rows_1[i].size} titles"
  i += 1
end

i = 0
until i == data_rows_1.size
  if data_rows_1[i].empty?
    abort "\nFailed. Terminated."
  end
  i += 1
end



#################### PART 2 ####################
# name: it_amazon_book_ext
# With given book_page_urls, go to each page and extract data
client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==")
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
    else
      puts "Got data!"
      puts JSON.pretty_generate(message["data"])
      data_rows_2 << message["data"]["results"]
    end
  end
  if query.finished
    query_num += 1
    puts "Book #{query_num} finished"
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

puts "All data received:"
puts JSON.pretty_generate(data_rows_2)

# Create a new json file unless it already exists
File.new('data/italy_part_2.json', 'w') unless File.exists?('data/italy_part_2.json')
# Open the file and write the data results to results_file.json
File.open('data/italy_part_2.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows_2)
end
