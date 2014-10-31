require "./importio.rb"
require "rubygems"
require "json"
require "formatador" 


#################### PART 1 ####################
# Import.io name: gr_search_title
# Search title

### Search query
title_to_search = "잠잘 시간이야"


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

# Query for tile gr_search_title
client.query({"input"=>{"query"=>title_to_search},"connectorGuids"=>["4fc63750-0c3e-408c-80bb-de4ef9d7611f"]}, callback )


puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

# Now we can print out the data we got
puts "All data received:"
puts JSON.pretty_generate(data_rows_1)

# Get book page urls from data_rows_1
book_page_urls = []
i = 0
n = 0
until i == data_rows_1.size
  until n == data_rows_1[i].size
    book_page_urls << data_rows_1[i][n]["title_url/_source"]
    n += 1
  end
  i += 1
  n = 0
end


puts "data_rows_1 size: #{data_rows_1[0].size}"

Formatador.display_line('[red]ENTERING PART 2...[/]')
sleep 2


#################### PART 2 ####################
# Import.io name: gr_book_ext
# With given book_page_urls, go to each title's page and find link to other editions

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
    puts "Query finished"
  end
end

# Query for tile gr_book_ext
book_page_urls.each do |url|
	client.query({"input"=>{"webpage/url"=>"https://www.goodreads.com#{url}"},"connectorGuids"=>["1f282dee-a743-4021-9baa-a07d13f45d9d"]}, callback )
end

puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

puts "All data received:"
puts JSON.pretty_generate(data_rows_2)


# Get urls to all editions page data_rows_2
link_to_other_editions = []
i = 0
n = 0
until i == data_rows_2.size
  until n == data_rows_2[i].size
    link_to_other_editions << data_rows_2[i][n]["link_to_other_editions"]
    n += 1
  end
  i += 1
  n = 0
end

Formatador.display_line('[red]ENTERING PART 3...[/]')
sleep 2

#################### PART 3 ####################
# Import.io name: gr_all_editions_ext
# With given link_to_all_editions from each titles, follow each link and extract data for all editions

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

# Query for tile gr_all_editions_ext
link_to_other_editions.each do |url|
	client.query({"input"=>{"webpage/url"=>url},"connectorGuids"=>["58c5497c-4139-47df-a908-8087e4f0a6bc"]}, callback )
end

puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

# Now we can print out the data we got
puts "All data received:"
puts JSON.pretty_generate(data_rows_3)