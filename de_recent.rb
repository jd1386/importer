require "./importio.rb"
require "json" 
require "csv"

#########################
#### GLOBAL SETTINGS ####

first_page = 1501
last_page = 1800

#########################

puts "Now deploying the pigeon"
puts "...in 3..." 
sleep 1
puts "...in 2..."
sleep 1
puts "...in 1..."


client = Importio::new("3f9ae37e-acfd-44f4-8157-e72adcc5b283","93CLLmP2bc/xrnSLz8b0BAsVyjebOMqgkxsEz/zmojXOtNoPd383KfJLaLXJqaaUzDY8bxZpfM5sDQKi4yUAxg==", "https://query.import.io")

client.disconnect
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
      if message["data"]["results"].length == 0
        puts "Oops. No data found!"
        data_rows << [{"title" => "N/A"}]
        sleep 2
      else
        puts "Got data!"
        puts JSON.pretty_generate(message["data"])
        data_rows << message["data"]["results"]
      end
    end
  end
  if query.finished
    puts "The pigeon picked #{first_page} / #{last_page}"
    first_page += 1
  end
end

# Query for tile DE_RECENT
#client.query({"input"=>{"webpage/url"=>"http://www.mayersche.de/buecher/kinderbuch-jugendbuch/?sprache=ger&sortby=publicationdate&sortorder=desc"},"connectorGuids"=>["e0e8f7c1-9c3a-4085-9849-b2c2f4baae11"]}, callback )

# page 2 and above
(first_page..last_page).each do |page|
  client.query({"input"=>{"webpage/url"=>"http://www.mayersche.de/buecher/kinderbuch-jugendbuch/#{page}/?force_sid=f9orlqco2irfda23uva2qj7p63&sprache=ger&sortby=publicationdate&sortorder=desc"},"connectorGuids"=>["e0e8f7c1-9c3a-4085-9849-b2c2f4baae11"]}, callback )
end

puts "Queries dispatched, now waiting for results"
client.join
puts "Join completed, all results returned"
client.disconnect

puts "All data received! Writing the results to the file. "
puts JSON.pretty_generate(data_rows)

# Write the results to the file
File.new('data/de_recent_results.json', 'w') unless File.exists?('data/de_recent_results.json')
File.open('data/de_recent_results.json', 'w') do |f|
  f << JSON.pretty_generate(data_rows)
end

puts "Done! The results saved to data/de_recent_results.json."

json_file = JSON.parse(File.open("data/de_recent_results.json").read)
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
CSV.open("data/de_recent_results.csv", "w") do |csv|
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
puts "The results saved to data/de_recent_results.csv"

# All done!
puts "와우! 비둘기가 성공적으로 돌아왔다!"
2.times.each do
  system('say "The pigeon has come back master" ')
  sleep 1
end