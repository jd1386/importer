require "./importio.rb"
require "json" 
require "csv"

#########################
#### GLOBAL SETTINGS ####

first_page = 1601
last_page = 1900

#########################

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
  	else
      puts "Got data!"
      puts JSON.pretty_generate(message["data"])
      data_rows << message["data"]["results"]
    end
  end
  if query.finished
    puts "Query #{first_page} / #{last_page} finished"
    first_page += 1
  end
end

# Query for tile FR_RECENT
# Page 1
# client.query({"input"=>{"webpage/url"=>"http://www.decitre.fr/livres/jeunesse.html?dir=desc&mode=list&order=dctr_publication_date"},"connectorGuids"=>["6d6fdbaa-243d-4a1b-a6e5-8c64a5069716"]}, callback )

# Page 2 and above
(first_page..last_page).each do |page|
  client.query({"input"=>{"webpage/url"=>"http://www.decitre.fr/livres/jeunesse.html?dir=desc&mode=list&order=dctr_publication_date?p=#{page}"},"connectorGuids"=>["6d6fdbaa-243d-4a1b-a6e5-8c64a5069716"]}, callback )
end


puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

# Now we can print out the data we got
puts "All data received! Writing the results to the file."

# Write the results to the file
File.new('data/fr_recent_results.json', 'w') unless File.exists?('data/fr_recent_results.json')
File.open('data/fr_recent_results.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows)
end

puts "Done! The results saved to data/fr_recent_results.json."

json_file = JSON.parse(File.open("data/fr_recent_results.json").read)
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
CSV.open("data/fr_recent_results.csv", "w") do |csv|
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
puts "The results saved to data/fr_recent_results.csv"

# All done!
puts "와우! 이번 미션은 성공적이었네. 축하하네."
