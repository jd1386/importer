## DESCRIPTION ##

require "./importio.rb"
require 'rubygems' 
require "json"



### Part 1 ### 

# Go to Kinokuniya and extract page urls of all the children's books listed
# After urls are extracted, save them to data_rows

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.connect

data_rows = []

 query_count = 1

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
      puts "Query finished"
    end
    query_count += 1
  end

client.query({"input"=>{"webpage/url"=>"http://www.kinokuniya.co.jp/f/dsd-001001020-01-"},"connectorGuids"=>["16bc6faf-f894-40fe-a1b9-2fb4d388fb52"]}, callback )

# Page 2 and above
# DISABLE QUERY FOR PAGE 2 AND ABOVE UNTIL REFACTORED
#(2..2).each do |page|
#	client.query({"input"=>{"webpage/url"=>"http://www.kinokuniya.co.jp/f/dsd-001001020-01-?p=#{page}"},"connectorGuids"=>["16bc6faf-f894-40fe-a1b9-2fb4d388fb52"]}, callback )
# end

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
puts "Extracting page urls from data_rows array"

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


### Part 2 ###

# With given urls, extract meta data from Kinokuniya

puts "\nNow entering part 2...Extracting meta data from Kinokuniya\n"
sleep 1

client.connect

data_rows_2 = []

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
puts JSON.pretty_generate(data_rows_2)


### Part 3 ###

# Now we have isbns from books listed in Kinokuniya
# We make queries for each isbn
# get_book_url_from_amazon_jp
# search_kinokuniya.rb saves a file containing list or book page urls
# This file reads the urls from the file and make queries for book category

puts "\nNow entering part 3...Going to Amazon JP\n"
sleep 1

book_isbn_collection = []

# Extract only isbn from book_page_url_collection
book_page_url_collection.each do |url|
  book_isbn_collection << url.gsub("http://www.kinokuniya.co.jp/f/dsg-01-", "")
end

puts book_isbn_collection
puts "Successfully extracted isbn and saved to book_isbn_collection"


client.connect

data_rows_3 = []

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
        data_rows_3 << message["data"]["results"]
      end
    end
    if query.finished
      puts "Query finished"
    end
  end


# Make queries for isbn on Amazon to get page url for each book
book_isbn_collection.each do |isbn|
  client.query({"input"=>{"isbn"=>isbn},"connectorGuids"=>["a4757afd-6317-4a4a-bba4-b33bdc4d6e6d"]}, callback )
end

puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"

client.disconnect

# Now we can print out the data we got
puts "All data received:"
puts JSON.pretty_generate(data_rows_3)


# Create a new json file unless it already exists
#File.new('data/data_rows_3_results.json', 'a') unless File.exists?('data/data_rows_3_results.json')

# Open the file and append the data results to results_file.json
#File.open('data/data_rows_3_results.json', 'a') do |f|
#  f << JSON.pretty_generate(data_rows_3)
#end

# Now we have the results file in json format.
# puts "The data is written to the data_rows_3_results.json file for inspection."

puts "Part 3 has ended. Now entering...Part 4"
sleep 1

### Part 4 ###

# Now we have all the amazon jp book page urls stored in data_rows_3.
# Fetch only urls from data_rows_3 and make queries to extract category for each title from Amazon JP

## Extract only book page urls and save them to book_page_url_collection to make queries

amazon_page_url_collection = []

puts "test begin"

puts data_rows_3.class
puts data_rows_3.count

i = 0
n = 0

puts data_rows_3[0][0]["book_page_url/_text"]
puts data_rows_3[1][0]["book_page_url/_text"]
puts data_rows_3[2][0]["book_page_url/_text"]

stop

i = 0
until i == data_rows_3.count
  amazon_page_url_collection << data_rows_3[i][0]["book_page_url"]

  i += 1
end

puts amazon_page_url_collection



client.connect

data_rows_4 = []

 query_count = 1

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
        data_rows_4 << message["data"]["results"]
      end
    end
    if query.finished
      puts "Query finished"
    end
    query_count += 1
  end



# Query for tile extract_category_amazon_jp using amazon_page_url_collection
amazon_page_url_collection.each do |url|
  client.query({"input"=>{"webpage/url"=>url},"connectorGuids"=>["a8fc3386-0d54-4785-ba1d-6dff1fb7c665"]}, callback )
end

puts "Queries dispatched, now waiting for results"

client.join

puts "Join completed, all results returned"

client.disconnect

# Now we can print out the data we got
puts "All data received:"
puts JSON.pretty_generate(data_rows_4)

# Create a new json file unless it already exists
File.new('data/extract_category_amazon_jp.json', 'w+') unless File.exists?('data/extract_category_amazon_jp.json')

# Open the file and write the data results to results_file.json
File.open('data/extract_category_amazon_jp.json', 'w+') do |f|
  f << JSON.pretty_generate(data_rows_4)
end

# Now we have the results file in json format.
puts "The data is written to the extract_category_amazon_jp.json file.\n"

puts "Attack on Japan has successfully accomplished!"