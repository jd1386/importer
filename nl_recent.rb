require "./importio.rb"
require "json" 
require "csv"

client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.connect
data_rows = []
q = 0

callback = lambda do |query, message|
  if message["type"] == "DISCONNECT"
    puts "The query was cancelled as the client was disconnected"
  end
  if message["type"] == "MESSAGE"
    if message["data"].key?("errorType")
      puts "Got an error!"
      puts JSON.pretty_generate(message["data"])
  	else
      puts JSON.pretty_generate(message["data"])
      data_rows << message["data"]["results"]
      q += 1
      puts "Got data #{q}!"
    end
  end
  if query.finished
    puts "Query finished"
  end
end

# Page 1
client.query({"input"=>{"webpage/url"=>"http://www.bol.com/nl/l/boeken/-/N/8299+8293+7143+11209/filter_Nf/12194+BTWN+0+100/filter_showNA/false/lijstid/30600010/sort/product_datum1/index.html"},"connectorGuids"=>["dea5138d-91b7-4d84-a092-d82401bc9590"]}, callback )

# Query for tile NL_RECENT
(2..5).each do |page|
  client.query({"input"=>{"webpage/url"=>"http://www.bol.com/nl/l/boeken/-/N/8299+8293+7143+11209/filter_Nf/12194+BTWN+0+100/filter_showNA/false/lijstid/30600010/page/#{page}/sort/product_datum1/index.html"},"connectorGuids"=>["dea5138d-91b7-4d84-a092-d82401bc9590"]}, callback )
end

puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

# Now we can print out the data we got
puts "All data received:"
puts JSON.pretty_generate(data_rows)

# Write the results to the file
File.new('data/nl_recent_results.json', 'w') unless File.exists?('data/nl_recent_results.json')
File.open('data/nl_recent_results.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows)
end

puts "Done! The results saved to data/nl_recent_results.json."

json_file = JSON.parse(File.open("data/nl_recent_results.json").read)
json_page_length = json_file.length
json_book_per_page_length = json_file[0].length


# Check if every book from every page has been scraped
puts "\n:::Results:::"
puts "Page\tBooks Scraped"
puts "----------------------"

i = 0
(i...json_page_length).each do 
  puts "page #{i + 1}\t#{json_file[i].length}"
  if json_file[i].length == 0
    puts "Oops, page #{i + 1} was not scraped. Please retry."
    abort
  end
i += 1
end

# If all the books are successfully scraped, convert JSON to CSV
CSV.open("data/nl_recent_results.csv", "w") do |csv|
  # Write header
  csv << json_file[0][0].keys
  
  # Write rows
  i = 0
  n = 0

  (i...json_page_length).each do 
    (n...json_file[i].length).each do 
      csv << json_file[i][n].values
      n += 1
    end
    n = 0
    i += 1
  end

end
puts "The results saved to data/nl_recent_results.csv"