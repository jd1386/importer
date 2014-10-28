require "./importio.rb"
require "json" 

######### DESCRIPTION #########
# This program extracts only children books from Aladin.
# Use or make another one to extract books for toddlers.


######### PART 1: GET BOOK PAGE URL #########

#GLOBAL SETTINGS---------------------------------
START_PAGE = 1
LAST_PAGE = 5
# Each list page has 0 to 99 titles: 100 totals
TITLES_PER_PAGE = 100
#------------------------------------------------

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.connect

book_page_urls = []

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
      book_page_urls << message["data"]["results"]
    end
  end
  if query.finished
    puts "Query finished"
  end
end

# Query for tile search_taiwan
(START_PAGE..LAST_PAGE).each do |page|
	client.query({"input"=>{"webpage/url"=>"http://www.books.com.tw/web/sys_nbmidme/books/14/?o=1&v=1&page=#{page}"},"connectorGuids"=>["2bfaffbc-8d98-4a7a-88d4-73c0ee0744cd"]}, callback )
end

puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

# Now we can print out the data we got
puts "All data received:"
puts JSON.pretty_generate(book_page_urls)


######### PART 2: EXTRACT BOOK META #########


client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.connect

book_metas = []

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
      book_metas << message["data"]["results"]
    end
  end
  if query.finished
    puts "Query finished"
  end
end

# Query for tile extract_taiwan

i = 0
n = 0


until i == LAST_PAGE
	until n == TITLES_PER_PAGE
		client.query({"input"=>{"webpage/url"=>book_page_urls[i][n]["book_page_url"]},"connectorGuids"=>["ddb042c2-811d-4bdd-a8c2-b6d31fa8ecf8"]}, callback )
		puts "Queried: #{i}: #{n}"
		n += 1
	end
	n = 0
	i += 1
end


puts "Queries dispatched, now waiting for results"

client.join
puts "Join completed, all results returned"
client.disconnect
puts "All data received:"
puts JSON.pretty_generate(book_metas)

# Save book meta
File.new('data/taiwan_results.json', 'w') unless File.exists?('data/taiwan_results.json')
File.open('data/taiwan_results.json', 'w') do |f|
  f << JSON.pretty_generate(book_metas)
end

# Now we have the results file in json format.
puts "The data is written to the taiwan_results.json file for inspection."
