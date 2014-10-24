## DESCRIPTION ##



require "./importio.rb"
require "json"
require 'rubygems' 

### Part 1
# Go to Kinokuniya and extract page urls of all the children's books listed
# After urls are extracted, they'll be later used to make query to Amazon JP.

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.connect

data_rows = []

callback = lambda do |query, message|
  # Disconnect messages happen if we disconnect the client library while a query is in progress
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
    puts "Query finished"
  end
end


# Page 1
client.query({"input"=>{"webpage/url"=>"http://www.kinokuniya.co.jp/f/dsd-001001020-01-"},"connectorGuids"=>["16bc6faf-f894-40fe-a1b9-2fb4d388fb52"]}, callback )

# Page 2 and above
(2..2).each do |page|
	client.query({"input"=>{"webpage/url"=>"http://www.kinokuniya.co.jp/f/dsd-001001020-01-?p=#{page}"},"connectorGuids"=>["16bc6faf-f894-40fe-a1b9-2fb4d388fb52"]}, callback )
end

puts "Queries dispatched, now waiting for results"

# Now we have issued all of the queries, we can wait for all of the threads to complete meaning the queries are done
client.join

puts "Join completed, all results returned"

client.disconnect

# Now we can print out the data we got
puts JSON.pretty_generate(data_rows)
puts "All data received."

# Create a new json file unless it already exists
File.new('data/search_kinokuniya_url_results.json', 'a') unless File.exists?('data/search_kinokuniya_url_results.json')

# Open the file and append the data results to results_file.json
File.open('data/search_kinokuniya_url_results.json', 'a') do |f|
  f << JSON.pretty_generate(data_rows)
end

# Now we have the results file in json format.
puts "The data is written to the search_kinokuniya_url_results.json file for inspection."


## Extract only book page urls

i = 0
n = 0
book_page_url_count = 0
book_page_url_collection = []

# There are 5 pages
until i == data_rows.count 
	# each page has 10 books
	until n == 10
		puts data_rows[i][n]['book_page_url']
		book_page_url_collection << data_rows[i][n]['book_page_url']
		book_page_url_count += 1
		n += 1
	end
	i += 1
	# Reset num_of_books
	n = 0
end

puts "\nBook page url count: #{book_page_url_count}"

puts "\nBooks page url collection:\n"

book_page_url_collection.each do |url|
	puts "Success: #{url}"
end


### Part 2
# With given urls, we can now make query for title by title and extract relevant info 

puts "\nNow entering part...\n"


client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.connect

data_rows = []

callback = lambda do |query, message|
  # Disconnect messages happen if we disconnect the client library while a query is in progress
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
    puts "Query finished"
  end
end

# Query for tile extract_kinokuniya
book_page_url_collection.each do |url|
	client.query({"input"=>{"webpage/url"=>url},"connectorGuids"=>["c25de259-b7ec-480e-9d86-c657603c245e"]}, callback )
end

puts "Queries dispatched, now waiting for results"

# Now we have issued all of the queries, we can wait for all of the threads to complete meaning the queries are done
client.join

puts "Join completed, all results returned"

client.disconnect

puts "All data received:"
puts JSON.pretty_generate(data_rows)

# Create a new json file unless it already exists
File.new('data/search_kinokuniya_results.json', 'w+') unless File.exists?('data/search_kinokuniya_results.json')

# Open the file and write the data results to results_file.json
File.open('data/search_kinokuniya_results.json', 'w+') do |f|
  f << JSON.pretty_generate(data_rows)
end

# Now we have the results file in json format.
puts "The data is written to the search_kinokuniya_results.json file."
