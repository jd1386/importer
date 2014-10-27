require "./importio.rb"
require "json" 

######### DESCRIPTION #########
# This program extracts only children books from Aladin.
# Use or make another one to extract books for toddlers.


######### PART 1: GET BOOK PAGE URL #########

#GLOBAL SETTINGS---------------------------------
START_PAGE = 81
LAST_PAGE = 100
# Each list page has 0 to 49 titles: 50 totals
TITLES_PER_PAGE = 49
#------------------------------------------------

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.connect

data_rows_search = []

page_queried_num = 0

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
      data_rows_search << message["data"]["results"]
    end
  end
  if query.finished
    page_queried_num += 1
    puts "Page #{page_queried_num} finished"
  end
end


(START_PAGE..LAST_PAGE).each do |page|
  client.query({"input"=>{"webpage/url"=>"http://www.aladin.co.kr/shop/wbrowse.aspx?BrowseTarget=List&ViewRowsCount=50&ViewType=Detail&PublishMonth=0&SortOrder=5&page=#{page}&PublishDay=84&CID=1108"},"connectorGuids"=>["55dc4a32-a664-4d36-af9b-8a88febc843d"]}, callback )
end

puts "Queries dispatched, now waiting for results"

client.join

puts "Join completed, all results returned"

client.disconnect

puts "All data received:"

book_page_url_collection = []
i = 0
n = 0
until i == data_rows_search.size # pages per list
  until n == TITLES_PER_PAGE # titles per page
    book_page_url_collection << data_rows_search[i][n]["book_page_url"]
    n += 1
  end
  n = 0 # reset n to iterate again
  i += 1
end

# Urls are now stored in book_page_url_collection
puts "Urls are now stored in book_page_url_collection. Jumping to PART 2..."

# Extract and save only isbns from book_page_url_colection
isbns = []
book_page_url_collection.each do |a|
  isbns << a.gsub("http://www.aladin.co.kr/shop/wproduct.aspx?ISBN=","")
end

# Join book_page_url_collection and isbns into one single array called urls_and_isbns

urls_and_isbns = book_page_url_collection | isbns



############### PART 2 ###############


# With given urls in book_page_url_collection, we'll now extract data from book by book

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.connect

data_rows_extracted = []
title_queried_num = 0

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
      data_rows_extracted << message["data"]["results"]
    end
  end
  if query.finished
    title_queried_num += 1
    puts "Title #{title_queried_num} finished"
  end
end

book_page_url_collection.each do |url|
  client.query({"input"=>{"webpage/url"=>url},"connectorGuids"=>["5b4000ac-193b-4c54-b1f8-49eec343a8c4"]}, callback )
end

puts "Queries dispatched, now waiting for results"

client.join

puts "Join completed, all results returned"

client.disconnect

puts "All data received:"
puts data_rows_extracted


# Save data_rows_extracted
File.new('data/korea_results.json', 'w') unless File.exists?('data/korea_results.json')
File.open('data/korea_results.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows_extracted)
end

# Save urls_and_isbns
File.new('data/korea_urls_and_isbns.json', 'w') unless File.exists?('data/korea_urls_and_isbns.json')
File.open('data/korea_urls_and_isbns.json', 'w') do |f|
  f << JSON.pretty_generate(urls_and_isbns)
end

# Now we have the results file in json format.
puts "The data is written to the korea_results.json file for inspection. And the book page url list is written to the korea_url_list.json file. \n Now merge the two files on excel after conversion to csv."