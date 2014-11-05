### To-Do's 
# 1. 문제: data_rows, data_rows_2와 data_rows_3 대조시 줄이 밀림
# 원인: 아마존 검색 결과에서 책이 2권이상 (보통은 하드/소프트커버 1권 + 이북 1권)이 있는 경우
# 2권 모두를 긁고 있음.
# 이런 경우 이북이 아닌 것만 긁거나, 긁더라도 array에서 빼야함.

# 2. 문제: italy_part_2.json 에서 null 이 뜨는 경우 null을 [{}]로 교체해줘야 함.


require "./importio.rb"
require "json" 

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
      data_rows << message["data"]["results"]
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

# Query for tile it_extract_feltrinelli
(66..80).each do |page|
  client.query({"input"=>{"webpage/url"=>"http://www.lafeltrinelli.it/libri-ragazzi/c-1045/0/#{page}/?cat2=1045&cat1=1&type=1&sort=0&pageSize=80"},"connectorGuids"=>["77373f6c-6584-427e-aa18-c542aa8e52f5"]}, callback )
end

puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

# Now we can print out the data we got
puts "All data received:"
puts JSON.pretty_generate(data_rows)

# Create a new json file unless it already exists
File.new('data/italy_feltrinelli.json', 'w') unless File.exists?('data/italy_feltrinelli.json')
# Open the file and write the data results to results_file.json
File.open('data/italy_feltrinelli.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows)
end


# Extract isbn from data_rows
isbns = []
i = 0
n = 0

until i == data_rows.size
  until n == data_rows[i].size
    puts data_rows[i][n]['book_page_url']
    isbns << data_rows[i][n]['book_page_url'].match(/[978].{12}/)
    n += 1
  end
  i += 1
  n = 0
end

puts "data_rows.size: #{data_rows[0].size}"


## STEP 2
# Go to Amazon.it and search for isbn
puts "\n... ENTERING STEP 2 ...\n"
sleep 1

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.connect
data_rows_2 = []
i = 0

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
    i += 1
    puts "Amazon Search #{i} finished"
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
File.new('data/italy_part_1.json', 'w') unless File.exists?('data/italy_part_1.json')
# Open the file and write the data results to results_file.json
File.open('data/italy_part_1.json', 'w') do |f|
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
